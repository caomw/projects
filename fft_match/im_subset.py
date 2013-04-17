import gdal
import numpy as np

class im_subset:
    def __init__(self, c0, r0, Nc, Nr, source, pad_val=0, Bands=(1,2,3)):
        self.source=source
        self.c0=c0
        self.r0=r0
        self.Nc=Nc
        self.Nr=Nr
        self.z=[]
        self.level=0  # if the level is zero, this is a copy of a file, if it's >0, it's a copy of a copy of a file
        self.Bands=Bands
        self.pad_val=pad_val

    def setBounds(self, c0, r0, Nc, Nr, update=0):
        self.c0=np.int(c0)
        self.r0=np.int(r0)
        self.Nc=np.int(Nc)
        self.Nr=np.int(Nr)
        if update > 0:
            self.copySubsetFrom(pad_val=self.pad_val)

    def copySubsetFrom(self, pad_val=0):
        if hasattr(self.source, 'level'):  # copy data from another subset
            self.z = np.zeros((self.source.z.shape[0], self.Nr, self.Nc), self.source.z.dtype) + pad_val
            (sr0, sr1, dr0, dr1, vr)=match_range(self.source.r0, self.source.Nr, self.r0, self.Nr)
            (sc0, sc1, dc0, dc1, vc)=match_range(self.source.c0, self.source.Nc, self.c0, self.Nc)
            if (vr & vc):
                self.z[:, dr0:dr1, dc0:dc1]=self.source.z[:,sr0:sr1, sc0:sc1]
            self.level=self.source.level+1
        else:  # read data from a file
            band=self.source.GetRasterBand(self.Bands[0][0])
            src_NB=self.source.RasterCount
            dt=gdal.GetDataTypeName(band.DataType)
            self.z=np.zeros((src_NB, self.Nr, self.Nc), dt)+pad_val
            (sr0, sr1, dr0, dr1, vr)=match_range(0, band.YSize, self.r0, self.Nr)
            (sc0, sc1, dc0, dc1, vc)=match_range(0, band.XSize, self.c0, self.Nc)
            if (vr & vc):
                a=self.source.ReadAsArray(int(sc0),  int(sr0), int(sc1-sc0), int(sr1-sr0))
                self.z[:, dr0:dr1, dc0:dc1]=a
            self.level=0

#     def writeSubsetTo(self, bands, target):
#         if target.level > 0:
#             print "copying into target raster"
#             (sr0, sr1, dr0, dr1, vr)=match_range(target.source.r0, target.source.Nr, self.r0, self.Nr)
#             (sc0, sc1, dc0, dc1, vc)=match_range(target.source.c0, target.source.Nc, self.c0, self.Nc)
#             if (vr & vc):
#                 for b in bands:
#                     target.source.z[b,sr0:sr1, sc0:sc1]=self.z[b, dr0:dr1, dc0:dc1]
#         else:
#             print "writing to file";
#             band=target.source.GetRasterBand(1)
#             (sr0, sr1, dr0, dr1, vr)=match_range(0, band.YSize, self.r0, self.Nr)
#             (sc0, sc1, dc0, dc1, vc)=match_range(0, band.XSize, self.c0, self.Nc)
#             print (sc0, sc1, dc0, dc1)
#             print (sr0, sr1, dr0, dr1)
#             print "vr=", vr, "vc=", vc
#             if (vr & vc):
#                 print "...writing..."
#                 for bb in (bands):
#                     band=target.source.GetRasterBand(bb)
#                     band.WriteArray( self.z[bb, dr0:dr1, dc0:dc1], int(sr0), int(sc0))



def match_range(s0, ns, d0, nd):
    i0 = max(s0, d0)
    i1 = min(s0+ns, d0+nd)
    si0=max(0, i0-s0)
    si1=min(ns, i1-s0)
    di0=max(0, i0-d0)
    di1=min(nd,i1-d0)
    any_valid=(di1>di0) & (si1 > si0)
    return (si0, si1, di0, di1, any_valid)
