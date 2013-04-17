#! /opt/local/bin/python

def log_filter(img):
    """
    performs a separable Laplacian of Gaussian filter on the input image.
    Returns a copy of the original image, converted to float64
    """
    img1 = np.float64(img.copy())
    img1 = sf.laplace( img1, mode='constant')
    if np.sum(img==0) > 0 :  #zero the filtered image at  data-nodata boundaries
        mask = np.float64(img.copy())
        mask[:] = 1.
        mask[img==0] = 0.
        mask=sf.laplace(mask, mode='constant')
        img1[mask != 0.] = 0.   # set the borders to zero
    img1 = sf.gaussian_filter(img1, (1.4, 1.4), mode='constant')
    return img1

# imports

import gdal
import gdalconst
import numpy as np
import scipy.ndimage.filters as sf
from im_subset import im_subset
from norm_xcorr import TemplateMatch
import scipy.stats as ss
from Queue import Queue
from threading import Thread
from multiprocessing import Pool, Process, Value, Array
import time

#import matplotlib.pyplot as plt

def run_one_block(params):

    # Do template matching for a single block in the left image.
    # The results are stored within the class itself and will be
    # extracted later.

    (count, t_pixels, KW, min_template_sigma, these_ind, Xc, Yc, s_nx,
     s_ny, dx0, dy0, T_img, S_img) = params

    # LOG filter the images
    T_filt=log_filter(T_img)
    S_filt=log_filter(S_img)
    std_T=np.std(T_filt)
    if not min_template_sigma is None:
        if std_T < min_template_sigma:
            return(-2, Xc, Yc, -1, -1, -1)

    # run the feature match.
    TT=T_filt[KW:t_pixels+KW, KW:t_pixels+KW]
    SS=S_filt[KW:s_ny+KW, KW:s_nx+KW]
    # If the search image is large, do an initial search at 2x lower resolution
    if (SS.shape[0] > 32+TT.shape[0]) or (SS.shape[1] >32+TT.shape[1]):
        TT1=TT[1:-1:2, 1:-1:2]
        SS1=SS[1:-1:2, 1:-1:2]
        TM=TemplateMatch(TT1, method='ncc')
        result=TM(SS1)
        result=result[(t_pixels/4):(s_ny/2-t_pixels/4), (t_pixels/4):(s_nx/2-t_pixels/4)]
        ijC = 2*(np.array(np.unravel_index(np.argmax(result), result.shape))-[result.shape[0]/2., result.shape[1]/2.]).astype(int)

        t_xr=np.array(ijC[1]+[-t_pixels/2-16, t_pixels/2+16]+SS.shape[1]/2, dtype=np.int16)
        t_yr=np.array(ijC[0]+[-t_pixels/2-16, t_pixels/2+16]+SS.shape[0]/2, dtype=np.int16)
        if t_xr[0] >= 0 and t_yr[0] >= 0 and t_xr[1] <= SS.shape[1] and t_yr[1] <= SS.shape[0] :
            dx0=dx0+ijC[1]
            dy0=dy0+ijC[0]
            SS=SS[t_yr[0]:t_yr[1], t_xr[0]:t_xr[1]]

    TM=TemplateMatch(TT, method='ncc')
    result=TM(SS)

    # trim off edges of result
    result=result[(t_pixels/2):(SS.shape[0]-t_pixels/2),
                  (t_pixels/2):(SS.shape[1]-t_pixels/2)]

    ij = np.unravel_index(np.argmax(result), result.shape)
    ijC=ij-np.array([result.shape[0]/2, result.shape[1]/2])

    return (result[ij], Xc, Yc, std_T, ijC[1]+dx0, ijC[0]+dy0)

class fft_matcher(object):
    """
    class to perform fft matches on a pair of image files.  Uses the GDAL
    API for reads and writes, and the norm_xcorr package to do the matching
    Arguments:
        For initialization:
            Tfile  The template file-- small images are extracted from this file
                and correlated against sub-images of Sfile
            Sfile  The search file.

        For correlation:
            t_pixels : Size of the square template
            s_nxy_i  : [2, N], array-like  search windows in x and y
                        to use at each center (n_columns, n_rows)
            dxy0_i   : [2, N], array-like  initial offset estimates
                        (delta_col,  delta_row)
            XYc_i    : [2,N] pixel centers to search in the template image
                        (col, row)

        Outputs from correlation:
            xyC     :  Pixel centers in the template image
            dxy     :  pixel offsets needed to shift the template to match the search image
            C       :  Correlation value for the best match (0<C<1).
                        -1 indicates invalid search or teplate data
    """
    def __init__(self, Tfile, Sfile):
        self.T_ds=gdal.Open(Tfile, gdalconst.GA_ReadOnly)
        self.T_band=self.T_ds.GetRasterBand(1)
        self.S_ds=gdal.Open(Sfile, gdalconst.GA_ReadOnly)
        self.S_band=self.S_ds.GetRasterBand(1)
        self.Nx=self.T_band.XSize
        self.Ny=self.T_band.YSize
        self.KW=13  # pad the edges by this amount to avoid edge effects
        self.S_sub=im_subset(0, 0, self.S_band.XSize, self.S_band.YSize,
                         self.S_ds, pad_val=0, Bands=[[1]])
        self.T_sub=im_subset(0, 0, self.T_band.XSize, self.S_band.YSize,
                         self.T_ds, pad_val=0, Bands=[[1]])

        GT_S=self.S_sub.source.GetGeoTransform()
        self.GT_S=GT_S
        self.UL_S=np.array([GT_S[0], GT_S[3]])
        LL_S=np.array([GT_S[0], GT_S[3]+self.S_sub.Nr*GT_S[5]])
        UR_S=np.array([GT_S[0]+self.S_sub.Nc*GT_S[1], GT_S[3]])

        GT_T=self.T_sub.source.GetGeoTransform()
        self.GT_T=GT_T
        self.UL_T=np.array([GT_T[0], GT_T[3]])
        LL_T=np.array([GT_T[0], GT_T[3]+self.T_sub.Nr*GT_T[5]])
        UR_T=np.array([GT_T[0]+self.T_sub.Nc*GT_T[1], GT_T[3]])

        XR=[np.max([LL_S[0], LL_T[0]]), np.min([UR_S[0], UR_T[0]])]
        YR=[np.max([LL_S[1], LL_T[1]]), np.min([UR_S[1], UR_T[1]])]
        self.XR=XR
        self.YR=YR
        self.T_c0c1=np.array([max([0, (LL_T[0]-XR[0])/GT_T[1]]), min(self.T_sub.Nc, (XR[1]-LL_T[0])/GT_T[1])]).astype(int)
        self.T_r0r1=np.array([max([0 , (YR[1]-UR_T[1])/GT_T[5]]), min([self.T_sub.Nr, (LL_T[1]-YR[1])/GT_T[5]])]).astype(int)

    def __call__(self, t_pixels, s_nxy_i, dxy0_i, XYc_i, min_template_sigma=None):
        KW=self.KW
        # loop over pixel centers
        self.C=np.zeros([XYc_i.shape[0], 1])-1
        self.sigma_template=(self.C).copy()
        self.dxy=np.zeros([XYc_i.shape[0], 2])
        self.xyC=np.zeros([XYc_i.shape[0], 2])

        blocksize=8192
        Ds2x=True     # this means: downsample by 2 to calculate an initial offset

        xg0, yg0=np.meshgrid(np.arange(0, self.T_band.XSize, blocksize), np.arange(0, self.T_band.YSize, blocksize))
        s_x_bounds=np.c_[XYc_i[:,0]+dxy0_i[:,0]-s_nxy_i[:,0]-KW-1000, XYc_i[:,0]+dxy0_i[:,0]+s_nxy_i[:,0]+KW+1000]
        s_y_bounds=np.c_[XYc_i[:,1]+dxy0_i[:,1]-s_nxy_i[:,1]-KW-1000, XYc_i[:,1]+dxy0_i[:,1]+s_nxy_i[:,1]+KW+1000]

        for xgi, ygi in zip(xg0.ravel(), yg0.ravel()):
            print('xgi, ygi ', xgi, ygi)

            # loop over the sub-blocks
            these=np.logical_and(np.logical_and(XYc_i[:,0] > xgi , XYc_i[:,0] <= xgi+blocksize), np.logical_and(   XYc_i[:,1] > ygi , XYc_i[:,1] <= ygi+blocksize))
            if ~np.any(these):
                continue
            self.T_sub.setBounds(xgi-t_pixels, ygi-t_pixels, blocksize+2*t_pixels, blocksize+2*t_pixels, update=1)
            self.S_sub.setBounds(s_x_bounds[these,0].min(),  s_y_bounds[these,0].min(),
                                 s_x_bounds[these,1].max()-s_x_bounds[these,0].min(), s_y_bounds[these,1].max()-s_y_bounds[these,0].min(), update=1)
            #print "reading size:(%f,%f)" % (s_x_bounds[these,1].max()-s_x_bounds[these,0].min(), s_y_bounds[these,1].max()-s_y_bounds[these,0].min())
            these_ind=np.array(np.nonzero(these)).ravel()

            count=-1
            TaskParams = []
            for Xc, Yc, s_nx, s_ny, dx0, dy0 in zip(XYc_i[these,0], XYc_i[these,1], s_nxy_i[these,0],
                                                    s_nxy_i[these,1], dxy0_i[these,0],
                                                    dxy0_i[these,1]):

                count=count+1

                #print('count is ', count)
                t_xr=[Xc-(t_pixels/2-1)-KW, Xc+(t_pixels/2)+KW]
                t_yr=[Yc-(t_pixels/2-1)-KW, Xc+(t_pixels/2)+KW]

                s_xr=[Xc+dx0-(s_nx/2-1)-KW, Xc+(s_nx/2)+KW]
                s_yr=[Yc+dy0-(s_ny/2-1)-KW, Yc+(s_ny/2)+KW]

                # Read in the data for this block. Use the im_subset objects:
                # read nodata if we read past the image edges.

                # Read T
                T_buffer=im_subset(0, 0, self.T_band.XSize, self.S_band.YSize,
                                   self.T_sub, pad_val=0)
                T_buffer.setBounds(t_xr[0]-KW, t_yr[0]-KW, t_pixels+2.*KW,
                                   t_pixels+2.*KW, update=1)
                T_img=T_buffer.z[0,:,:]
                if np.mean(T_img==0)>.1: # bail if > 10% 0, flag with C=-2
                    continue

                # Read S
                S_buffer=im_subset(0, 0, self.S_band.XSize, self.S_band.YSize,
                                   self.S_sub, pad_val=0)
                S_buffer.setBounds(s_xr[0]-KW, s_yr[0]-KW, s_nx+2.*KW,
                                   s_ny+2.*KW, update=1)
                S_img=S_buffer.z [0,:,:]
                if np.mean(S_img==0)> .25:  # bail if > 25% 0
                    continue

                # To do: Not all these parameters are necessary on the
                # other side!
                params = ( count, t_pixels, KW, min_template_sigma, these_ind,
                           Xc, Yc, s_nx, s_ny, dx0, dy0, T_img.copy(), S_img.copy() )
                TaskParams.append(params)

            # To do: num processes must be a param!

            pool = Pool(processes=16)
            Out = pool.map(run_one_block, TaskParams)
            for i in range(len(TaskParams)):
                params = TaskParams[i]
                #out = run_one_block(params) # single-threaded
                out = Out[i]
                count = params[0] # Need not have count == i.
                self.C[these_ind[count]]=out[0]
                self.xyC[these_ind[count]]=[out[1], out[2]]
                if out[3] >= 0:
                    self.sigma_template[these_ind[count]]=out[3]
                    self.dxy[these_ind[count],:]=[out[4], out[5]]

        return (self.xyC).copy(), (self.dxy).copy(), (self.C).copy(), (self.sigma_template).copy()

#            print ij
#            plt.figure(figsize=(6,9))
#            plt.subplot(2,2,1)
#            plt.imshow(SS)
#            plt.subplot(2,2,2)
#            plt.imshow(TT)
#            plt.subplot(2,2,3)
#            plt.imshow(result)
#            plt.subplot(2,2,4)

#            print [(ij[0]-T_img.shape[0]/2), (ij[0]+T_img.shape[0]/2)]
#            print [(ij[1]-T_img.shape[1]/2), (ij[1]+T_img.shape[1]/2)]
#             Imatch=SS[(ijC[0]-TT.shape[0]/2):(ijC[0]+TT.shape[0]/2), (ijC[1]-TT.shape[1]/2):(ijC[1]+TT.shape[1]/2)]
#            plt.imshow(Imatch)
#            plt.show()
