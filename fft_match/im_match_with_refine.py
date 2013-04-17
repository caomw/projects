#! /opt/local/bin/python

import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import coo_matrix 
from scipy.interpolate import griddata
import scipy.stats as ss
import scipy.spatial as sp
from optparse import OptionParser
import fft_matcher
import sys, os
import gdalconst
import datetime
 
def make_pt_2_neighbors(tri):
    """
    make a dictionary of the neighbors of each point in triangulation 
    tri
    """
    pt_dict=dict()
    for vlist in tri.vertices:
        for i in vlist:
            if not i in pt_dict:
                pt_dict[i]=list()
            for k in vlist:
                if k != i:
                    pt_dict[i].insert(0,k)      
    for i in range(tri.points.shape[0]):
        pt_dict[i]=np.unique(pt_dict[i]).tolist()        
    return pt_dict

 
def unique_rows(data):
    """
    return the indices for he unique rows of matrix (data)
    """
    udict = dict()
    for row in range(len(data)):
        row_data = tuple(data[row,:])
        if not row_data in udict:
            udict[row_data] =row
    uInd=udict.values()
    uRows=np.c_[udict.keys()]
    return uInd, uRows

def search_new_pts(xy, dxy, t_size, matcher, min_template_sigma=0.):
    """
    use an image matcher object to perform a template match between
    two images at the points defined by xy, using search windows that 
    span the range in dxy
    """
    dxy0 = np.c_[dxy[:,0]+dxy[:,1], dxy[:,2]+dxy[:,3]]/2.
    dxyR = np.c_[dxy[:,1]-dxy[:,0], dxy[:,3]-dxy[:,2]]
    sw = np.array(2.**np.ceil(np.log2(np.maximum(dxyR+t_size, t_size+16))))
    xy_new, dxy_new, C_new, Pt_new= matcher(t_size, sw, dxy0, xy, min_template_sigma=min_template_sigma)
    xy_bad_mask=xy_new[C_new.ravel()==-2,:]
    good=C_new>0    
    xy_new=xy_new[good.ravel(),:]
    dxy_new=dxy_new[good.ravel(),:]
    C_new=C_new[good.ravel()] 
    Pt_new=Pt_new[good.ravel()]
    return xy_new, dxy_new, C_new, xy_bad_mask 

def nbhd_range(pt_list, dx_mat, dy_mat, tri, pt_dict, max_dist=None, calc_min_slope=None):
    """
    for each point in pt_list, return the maximum and minimum offset
    for its neighbors.
    inputs:
        pt_list:  list of points to be searched
        dx_mat: sparse matrix with x disparity values for each pixel in the
                template image
        dy_may: ditto, but for y
        tri:    a triangulation.  th points field in this triangulation is
                used to get the x and y offsets for the point indices
        pt_dict:  a dictionary giving the neighbor point numbers for each 
                  point in tri
    output:
        dx_range: an Nx4 martix.  columns 0 and 1 give the min and max x
        offsets around each point, columns 2 and 3 give the min and max y.
    """
    dxy_range=np.zeros([len(pt_list), 4])
    if calc_min_slope is not None:
        dxy_slope=np.zeros([len(pt_list), 2])
    for row, pt in enumerate(pt_list):
        neighbors=pt_dict[pt]
        nbhd_pts=tri.points[neighbors,:]
        this_pt=tri.points[pt,:]
        if max_dist is not None:            
            dist2=(nbhd_pts[:,1]-this_pt[1])**2 + (nbhd_pts[:,0]-this_pt[0])**2
            nbhd_pts=nbhd_pts[dist2 < max_dist**2,:]
        if nbhd_pts is None:
            dxy_range[row,:]=0.
        dx_vals=np.append(np.array(dx_mat[nbhd_pts[:,1], nbhd_pts[:,0]]), dx_mat[this_pt[1], this_pt[0]])
        dy_vals=np.append(np.array(dy_mat[nbhd_pts[:,1], nbhd_pts[:,0]]), dy_mat[this_pt[1], this_pt[0]])
        if calc_min_slope is not None:
            dist=np.sqrt((nbhd_pts[:,1]-this_pt[1])**2 + (nbhd_pts[:,0]-this_pt[0])**2)
            dx_slope=np.abs(dx_vals[0:-1]-dx_vals[-1])/dist
            dy_slope=np.abs(dy_vals[0:-1]-dy_vals[-1])/dist
            dxy_slope[row,:]=[np.min(dx_slope), np.min(dy_slope)];
                               
        dxy_range[row,[0,1]]=[np.min(dx_vals), np.max(dx_vals)]
        dxy_range[row,[2,3]]=[np.min(dy_vals), np.max(dy_vals)]
    if calc_min_slope is not None:
        return dxy_range, dxy_slope
    else:
        return dxy_range ##, dxy_bar

def test_epipolar(dxy_0, ep_vec, dxy, tol):
    """
    given an origin vector and an epipolar unit vector, projects a set of 
    points against the epipolar vector and gives their perpendicular offset
    WRT that vector, and a boolean array that shows whether this offset is 
    smaller that tol.
    """
    delta=np.abs(np.dot((dxy-dxy_0), [ep_vec[1], -ep_vec[0]]))
    return (delta < tol), delta

def est_epipolar_vec(dxy, C, C_tol):
    """
    given a set of offsets and correlation values:
        For those point with  C>C_tol, find the median offset and the 
        eigenvectors of the distribution of the points around that median
        offset.  The eigenvector corresponding to the largest eigenvalue is
        assumed to be the epipolar vector.
    """
    good=np.array(C>C_tol, dtype=bool)
    dxy1=np.array(dxy[good.ravel(),:])
    dxy_ctr=[np.median(dxy1[:,0]), np.median(dxy1[:,1])]
    dxy_0=dxy1-dxy_ctr
    vals, vecs=np.linalg.eig(np.dot(dxy_0.transpose(), dxy_0))
    biggest_vec=vecs[:,np.argmax(abs(vals)) ]
    return biggest_vec, dxy_ctr

def main():
    """ For a pair of images, perform a sparse image match using the full 
    resolution of the images.  Begin at resolution coarse_skip.  For each
    point in a grid spanning the image 1, extract a template image of
    size t_pixels, and use fft-based correlation to find its match in image 2, 
    over a wide search window (size xsearch by ysearch).  Based on matches from
    this coarse grid, estimate an epipolar vector (the largest eigenvector of 
    the disparity vectors) and a tolerance for disparities to be parallel to
    this vector (use max (16 pix, 90th percentile of differeces)).
    
    Next, refine points for which the range of disparities among the 
    neighbors are larger than tolerance refine_tol.  Refinement consists
    of adding the eight grid neighbors of a point, at half the previous
    point spacing.  During refinment, the search windows are selected to span
    the neighbors' x and y disparities, and are padded by 16 pixels and padded
    again to give a power-of-two search size.
    
    After each refinement, the new matches are checked againt the epipolar 
    vector, and all the matched points are checked for convergence.  Refinment 
    continues until the point spacing reaches fine_skip, or until no points
    need to be refined.
    
    Results are written to oufile:
        pixel_x
        pixel_y
        x_disparity
        y_diparity
        correlation value
        (max-min) neighbor x disparity
        (max-min) neighbor y disparity
     """
    dxy_slope_tol=3.0
    C_tol=0.4  # minimum quality needed in defining the epipolar vector estimate
    usage = "usage: %prog [options] T_file S_file"
    parser=OptionParser(usage)
    parser.add_option("-o", "--outfile", dest="outfile", default="match_out",
                      help="output file is OUTFILE", metavar="OUTFILE")
    parser.add_option("-x", "--xsearch", dest="s_nx", default=1024-56, type="int",
                      help="initial x search range, pixels")
    parser.add_option("-y", "--ysearch", dest="s_ny", default=1024-56, type="int",
                      help="initial y search range, pixels")
    parser.add_option("-t", "--template", dest="t_pixels", default=56, type="int",
                      help="template size, pixels")      
    parser.add_option("-c", "--coarse", dest="coarse_skip", default=512, type="int",
                      help="initial search-point spacing")
    parser.add_option("-f", "--fine", dest="fine_skip", default=32, type="int",
                      help="final search-point spacing")
    parser.add_option("-r","--refine_tol", dest="refine_tol", default=8, type="int", 
                      help="pixel range tolerance for refinement")     
    parser.add_option("-d","--output_dec_scale", dest="output_scale",  default=6, type="int", 
                      help="if set, output a second copy of the offsets scaled by this amount, to file called OUTFILE_(OUTPUT_SCALE)")     
    parser.add_option("-p","--output_pad",dest="output_pad", default=2, type="int", 
                      help="pad the output search range by this amount")     
    parser.add_option("-s", "--sigma_t_min", dest="sigma_t_min",  default=10., type="float", 
                       help="matches will not be calculated if the standard deviation of the template is less than this value")
    parser.add_option("-R", "--R_max", dest="R_max",  default=40., type="float", 
                       help="Points whose neighbors have a minimum disparity range larger than this value will be removed")
    parser.add_option("-M", "--Max_disp_range", dest="M_max",  default=64., type="float", 
                       help="Un-scaled disparity range in output limited to this value")

    (options, args) = parser.parse_args()
     
    T_file=args[0]
    S_file=args[1]
    sys.stdout.flush()
    print str(datetime.datetime.now())
    print "T_file="+T_file
    print "S_file="+S_file
    s_nx=options.s_nx
    s_ny=options.s_ny
    t_pixels=options.t_pixels

    out_dir=os.path.dirname(options.outfile)
    if len(out_dir)==0:
        out_dir='.'
    
    skip_vals=2.**np.arange(np.floor(np.log2(options.coarse_skip/2.)), 
                            np.floor(np.log2(options.fine_skip/2.)), -1)

    #initialize the matcher object
    ftm=fft_matcher.fft_matcher(T_file, S_file)
    
    # define the initial search points
    edge_pad=np.array([s_nx/2+t_pixels/2, s_ny/2+t_pixels/2])
    [XCg, YCg]=np.meshgrid(np.arange(ftm.T_c0c1[0]+edge_pad[0],
                     ftm.T_c0c1[1]-edge_pad[0], options.coarse_skip), 
         np.arange(ftm.T_r0r1[0]+edge_pad[1], 
                   ftm.T_r0r1[1]-edge_pad[1], options.coarse_skip) )
    XY0=np.c_[XCg.ravel(), YCg.ravel()]
  
    # find the offset that matches the origins of the two images
    D_origin=np.c_[np.floor(ftm.UL_T-ftm.UL_S)].transpose()
    
    dxy0=np.dot(np.c_[np.ones_like(XY0[:,0])], D_origin*[1, -1])
    dxy_score=np.c_[dxy0[:,0]-s_nx/2., dxy0[:,0]+s_nx/2, dxy0[:,1]-s_ny/2, dxy0[:,1]+s_ny/2]
    xy, dxy, C, xy_bad_mask = search_new_pts(XY0, dxy_score, t_pixels, ftm, min_template_sigma=options.sigma_t_min)
     
    # run the epipolar fit, establish a tolerance, run again
    ep_vec, dxy_ctr=est_epipolar_vec(dxy, C, C_tol)
    good, ep_dist=test_epipolar(dxy_ctr, ep_vec, dxy, 32)
    ep_tol=np.minimum(16,np.maximum(8, ss.scoreatpercentile(ep_dist[C.ravel()>C_tol], 90)))
    if np.any(~good):
        ep_vec, dxy_ctr=est_epipolar_vec(dxy[good,:], C[good,:], C_tol)
        ep_tol=np.minimum(16,np.maximum(4, ss.scoreatpercentile(ep_dist[C.ravel()>C_tol], 90)))
        good, ep_dist=test_epipolar(dxy_ctr, ep_vec, dxy, ep_tol)
    print " --- ep tol estimated at(%f,%f), tol=%f" % (ep_vec[0], ep_vec[1], ep_tol)
    # make sparse matrices for storing dx and dy values, store initial values
    im_shape=[ftm.Ny, ftm.Nx]
    dx_mat=coo_matrix((dxy[good,0],(xy[good,1],xy[good,0])), shape=im_shape).tocsr()
    dy_mat=coo_matrix((dxy[good,1],(xy[good,1],xy[good,0])), shape=im_shape).tocsr()
    C_mat=coo_matrix(((C[good]).ravel(), (xy[good,1], xy[good,0])), shape=im_shape).tocsr()
    bad_mask_mat = coo_matrix((np.ones_like(xy_bad_mask[:,0]), (xy_bad_mask[:,1], xy_bad_mask[:,0])), shape=im_shape).tocsr()
    xy_list=xy[good,:]
    # points tested so ar are the nozero members of C_mat
    all_pts=np.c_[C_mat.nonzero()];
    all_pts=all_pts[:,[1,0]];
    tri=sp.Delaunay(all_pts)
    pt_dict=make_pt_2_neighbors(tri)
    
    dxy_score=nbhd_range(np.arange(0, all_pts.shape[0]), dx_mat, dy_mat, tri, pt_dict)
    refine_pts=np.arange(0, xy_list.shape[0] )
    # define the pattern of pixel centers to refineat each steps.  Duplicates
    # will be deleted.
    refine_x=np.array([-1., 0.,  1., -1.,  1., -1., 0.,  1.])
    refine_y=np.array([ -1., -1., -1., 0., 0., 1., 1., 1. ]);
     
    for delta_x in skip_vals:
        print "----------refining to %d---------" % delta_x
        print str(datetime.datetime.now())
        if len(refine_pts)==0:
            print "    No refinement points for scale: %d" % delta_x
            break
        # add neighbors of the last set of points to the list
        sc=plt.scatter(all_pts[refine_pts,0], all_pts[refine_pts,1], c=dxy_score[:,1]-dxy_score[:,0]); plt.axis('equal'); plt.colorbar(sc)
        new_x=np.tile(all_pts[refine_pts, 0], [8,1]).transpose()+refine_x*delta_x
        new_y=np.tile(all_pts[refine_pts, 1], [8,1]).transpose()+refine_y*delta_x
        # the search range for the new points is set based on the min and max of the dxy_scores of the refined points
        new_dxy_score=np.array([np.tile(dxy_score[:,0], [8,1]).transpose().ravel(), 
                       np.tile(dxy_score[:,1], [8,1]).transpose().ravel(), 
                       np.tile(dxy_score[:,2], [8,1]).transpose().ravel(), 
                       np.tile(dxy_score[:,3], [8,1]).transpose().ravel()]).transpose()   
        new_xy=np.array([new_x.ravel(), new_y.ravel()]).transpose()
        uRows, new_xy=unique_rows(new_xy)
        new_dxy_score=new_dxy_score[uRows,:]
        N_search=new_xy.shape[0]
        
        new_xy, new_dxy,  new_C, new_xy_bad=search_new_pts(new_xy, new_dxy_score, t_pixels, ftm, min_template_sigma=options.sigma_t_min)   
        if len(new_xy)==0:
            print "    no new points found"
            break
        
        good, ep_dist=test_epipolar(dxy_ctr, ep_vec, new_dxy, ep_tol)     
        print "    searched %d points, found %d good matches" % (N_search, np.sum(good) )
        # add the new points to the sparse matrix of tested points
        dx_mat=dx_mat+coo_matrix((new_dxy[good,0], [new_xy[good,1], new_xy[good,0]]), im_shape).tocsr()
        dy_mat=dy_mat+coo_matrix((new_dxy[good,1], [new_xy[good,1], new_xy[good,0]]), im_shape).tocsr()
        C_mat=C_mat+coo_matrix(((new_C[good]).ravel(), [new_xy[good,1], new_xy[good,0]]), im_shape).tocsr()
        bad_mask_mat = bad_mask_mat + coo_matrix((np.ones_like(new_xy_bad[:,0]), (new_xy_bad[:,1], new_xy_bad[:,0])), shape=im_shape).tocsr()
        bad=~good
        bad_mask_mat = bad_mask_mat + coo_matrix((np.ones_like(new_xy[bad,1]), (new_xy[bad,1], new_xy[bad,0])), shape=im_shape).tocsr()

        #ID_new_pts=lil_matrix((np.ones_like(new_dxy[good,0]), [new_xy[good,1], new_xy[good,0]]), im_shape).tocsr()
         
        all_pts=np.c_[C_mat.nonzero()];
        all_pts=all_pts[:,[1,0]];
        # extract the dx and dy values, re-estimate the ep vector
        dxy=np.array(np.c_[dx_mat[all_pts[:,1], all_pts[:,0]].transpose(), dy_mat[all_pts[:,1], all_pts[:,0]].transpose()])
        C= np.array(C_mat[all_pts[:,1], all_pts[:,0]].transpose())
        ep_vec, dxy_ctr=est_epipolar_vec(dxy, C, C_tol)
        
        # triangulate all the good points so far
        tri=sp.Delaunay(all_pts)
        pt_dict=make_pt_2_neighbors(tri)
        # zero out points for which delta(disparity)/delta(dist) is too large
        dxy_score, min_dxy_slope=nbhd_range(range(all_pts.shape[0]), dx_mat, dy_mat, tri, pt_dict, calc_min_slope=True)
        bad=np.max(min_dxy_slope, axis=1) > dxy_slope_tol
        print "---deleting %d points that failed the d(disparity)/d(dist) test" % np.sum(bad) 
        if bad is not None:
            C_mat=C_mat.tolil()
            C_mat[all_pts[bad,1], all_pts[bad,0]]=0
            C_mat=C_mat.tocsr()
            bad_mask_mat = bad_mask_mat + coo_matrix((np.ones_like(all_pts[bad,1]), (all_pts[bad,1], all_pts[bad,0])), shape=im_shape).tocsr()

            all_pts=np.c_[C_mat.nonzero()]
            all_pts=all_pts[:,[1,0]];
            tri=sp.Delaunay(all_pts)
            pt_dict=make_pt_2_neighbors(tri)
            dxy_score = nbhd_range(range(all_pts.shape[0]), dx_mat, dy_mat, tri, pt_dict)

         
        ## don't refine if we're on the last value of the refinement list
        if delta_x == skip_vals[-1]:
            continue
        test_pts=np.arange(0, all_pts.shape[0])
        # test the new points and their neighbors for convergence 
        to_refine=np.logical_or((dxy_score[:,1]-dxy_score[:,0]>options.refine_tol), (dxy_score[:,3]-dxy_score[:,2]) > options.refine_tol)
        refine_pts=test_pts[to_refine,:]
        dxy_score=dxy_score[to_refine,:]
        # N.B.  we can often end up refining more points than we searched on the 
        # last round, because points from previous rounds can get marked for
        # refinement
        print "    found %d points to refine" %  len(refine_pts) 
    
    # filter out the 99th percentile of matches
    R_dx=dxy_score[:,1]-dxy_score[:,0]
    R_dy=dxy_score[:,3]-dxy_score[:,2]
  
    R_dx_mat=coo_matrix((R_dx, [all_pts[:,1], all_pts[:,0]]), im_shape).tocsr()
    R_dy_mat=coo_matrix((R_dy, [all_pts[:,1], all_pts[:,0]]), im_shape).tocsr()     
    R_dxy_score=nbhd_range(range(all_pts.shape[0]), R_dx_mat, R_dy_mat, tri, pt_dict) 
    P98=(ss.scoreatpercentile(R_dxy_score[:,0], 98), ss.scoreatpercentile(R_dxy_score[:,2], 99))
    R_max = np.minimum(P98, options.R_max)

    bad_xy=all_pts[np.logical_or((R_dxy_score[:,0] > R_max[0]) ,  (R_dxy_score[:,2] > R_max[1])),:]
    bad_mask_mat = bad_mask_mat + coo_matrix((np.ones_like(bad_xy[:,1]), (bad_xy[:,1], bad_xy[:,0])), shape=im_shape).tocsr()

    print "rejecting %d detected outliers using the minimum-disparity-difference test with R_max = %f, %f" % (bad_xy.shape[0], R_max[0], R_max[1])
    # delete the bad values  (prob don't need to delete from dx, dy_mat)
    for bad in bad_xy: 
        dx_mat[bad[1], bad[0]]=0
        dy_mat[bad[1], bad[0]]=0
        C_mat[bad[1], bad[0]]=0
    all_pts=np.c_[C_mat.nonzero()];
    all_pts=all_pts[:,[1,0]];
    # triangulate all the good points so far
    tri=sp.Delaunay(all_pts)
    pt_dict=make_pt_2_neighbors(tri)
 
    # check the score for output, ignore differences for points separated by more than 2*coarse skip
    dxy_score=nbhd_range(range(all_pts.shape[0]), dx_mat, dy_mat, tri, pt_dict, max_dist= 2.*options.coarse_skip)
    R_dx=dxy_score[:,1]-dxy_score[:,0]
    R_dy=dxy_score[:,3]-dxy_score[:,2]
 
    print "--------output stats------"
    for pct in (99, 95, 90, 84):
        P= (pct, ss.scoreatpercentile(R_dx, pct), ss.scoreatpercentile(R_dy, pct))
        print "%dth percetiles (rx,ry) = (%5.2f %5.2f)" % P
    
    dx=dx_mat[all_pts[:,1], all_pts[:,0]].transpose()
    dy=dy_mat[all_pts[:,1], all_pts[:,0]].transpose()
    C=C_mat[all_pts[:,1], all_pts[:,0]].transpose()
    
    # transform the pixel centers to map coordinates
    GT=ftm.GT_S
    xy=np.c_[GT[0]+all_pts[:,0]*GT[1]+all_pts[:,1]*GT[2], GT[3]+all_pts[:,0]*GT[4]+all_pts[:,1]*GT[5]]
    out=np.c_[xy, dx , dy , C, dxy_score[:,1]-dxy_score[:,0]+options.output_pad, dxy_score[:,3]-dxy_score[:,2]+options.output_pad] 
    outfile=open(options.outfile+'.csv','w')
    outfile.write('x, y, dx, dy, C, R_dx, R_dy\n')
    for line in out:
        outfile.write("%7.0f, %7.0f, %7.0f, %7.0f, %4.2f, %7.0f, %7.0f\n" %  tuple(x for x in line.tolist()[0]))
    outfile.close
#    # spit out the good and bad masks
    good_xy=np.c_[C_mat.nonzero()][:,[1, 0]]
    good_xy=np.c_[GT[0]+good_xy[:,0]*GT[1]+good_xy[:,1]*GT[2], GT[3]+good_xy[:,0]*GT[4]+good_xy[:,1]*GT[5]]
#
    bad_xy=np.c_[bad_mask_mat.nonzero()][:,[1, 0]]
    bad_xy=np.c_[GT[0]+bad_xy[:,0]*GT[1]+bad_xy[:,1]*GT[2], GT[3]+bad_xy[:,0]*GT[4]+bad_xy[:,1]*GT[5]]
   
    if options.output_scale > 0.:
        out=out/options.output_scale
        # scale x, y, and C back up by output_scale
        for col in [0, 1, 4]:
            out[:,col]=out[:,col]*options.output_scale       
        driver = ftm.T_ds.GetDriver()        
        delta_x=options.output_scale*np.abs(GT[1])
        x0=GT[0] 
        y0=GT[3]                
        x0=delta_x*(np.ceil(x0/delta_x))
        y0=delta_x*(np.ceil(y0/delta_x))
        Gdx=GT[1]*options.output_scale
        Gdy=GT[5]*options.output_scale

        GT1=np.array(GT)
        GT1[0]=x0; 
        GT1[3]=y0;
        GT1[1]=Gdx
        GT1[5]=Gdy
        nx1=np.int(im_shape[1]/options.output_scale)
        ny1=np.int(im_shape[0]/options.output_scale)
        xg, yg=np.meshgrid((np.arange(0, nx1)+0.5)*Gdx+x0, (np.arange(0, ny1)+0.5)*Gdy+y0)
        outDs = driver.Create(out_dir+'/D_sub.tif',  nx1, ny1, 3, gdalconst.GDT_Int32)        
        # interoate the scaled dx and dy values
        zi = np.nan_to_num(griddata(out[:,0:2], out[:,2], (xg, yg), method='linear'))
        outBand = outDs.GetRasterBand(1)
        outBand.WriteArray(zi[:,:,0])
        zi = np.nan_to_num(griddata(out[:, 0:2], out[:,3], (xg, yg), method='linear'))
        outBand = outDs.GetRasterBand(2)
        outBand.WriteArray(zi[:,:,0])
        goodbad=np.append(np.c_[good_xy, np.ones([good_xy.shape[0], 1])], np.c_[bad_xy, np.zeros([bad_xy.shape[0], 1])], 0)
        quality =  np.nan_to_num(np.round(griddata(goodbad[:,0:2], goodbad[:,2], (xg, yg), method='linear'))).astype(np.int32)
        outBand = outDs.GetRasterBand(3)
        outBand.WriteArray(quality)
        outDs.SetGeoTransform(tuple(GT1))
        outDs.SetProjection(ftm.T_ds.GetProjection())
        outDs=None
        
        outDs = driver.Create(out_dir+'/D_sub_spread.tif',  nx1, ny1, 3, gdalconst.GDT_Int32)
        # clip the output range to the specified limits
        out[:,5]=np.minimum(out[:,5], options.M_max/options.output_scale)
        out[:,6]=np.minimum(out[:,6], options.M_max/options.output_scale)

        # interpolate the scaled range values
        zi = np.nan_to_num(griddata(out[:,0:2], out[:,5], (xg, yg), method='linear'))
        outBand = outDs.GetRasterBand(1)
        outBand.WriteArray(zi[:,:,0])
        zi = np.nan_to_num(griddata(out[:, 0:2], out[:,6], (xg, yg), method='linear'))
        outBand = outDs.GetRasterBand(2)
        outBand.WriteArray(zi[:,:,0])
        goodbad=np.append(np.c_[good_xy, np.ones([good_xy.shape[0], 1])], np.c_[bad_xy, np.zeros([bad_xy.shape[0], 1])], 0)
        quality =  np.nan_to_num(np.round(griddata(goodbad[:,0:2], goodbad[:,2], (xg, yg), method='linear'))).astype(np.int32)
        outBand = outDs.GetRasterBand(3)
        outBand.WriteArray(quality)
        outDs.SetGeoTransform(tuple(GT1))
        outDs.SetProjection(ftm.T_ds.GetProjection())
        outDs=None
       
        
        
#       # spit out the good and bad masks
#        outfile=open('quality_mask_pts_by_%d.csv' % options.output_scale,'w')
#        outfile.write('x, y, quality\n')
#        for line in good_pts:
#            outfile.write('%9.5f, %9.5f, 1.0\n' % (line[1]/options.output_scale, line[0]/options.output_scale))
#        for line in bad_pts:
#            outfile.write('%9.5f, %9.5f, 0.0\n' % (line[1]/options.output_scale, line[0]/options.output_scale))
#        outfile.close()
#    
if __name__=="__main__":
    main()



                 
