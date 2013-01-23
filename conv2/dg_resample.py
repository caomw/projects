#! /usr/bin/env python

"""
David Shean
dshean@gmail.com
2/25/12

Note: need to add many checks, this is a work in progress

This script will resize an image and update relevant xml tags for ASP
"""

import sys, os, shutil
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta

#import gdal

#Scale relevant XML tag text (e.g. NUMROWS) by scale factor s and write out new file
def scalexml(xml_infilename, xml_outfilename, s):

	tree = ET.parse(xml_infilename)

	#Integer tags that will decrease 
	taglist = ['NUMROWS', 'NUMCOLUMNS']
	for tag in taglist:
		elem = tree.find('.//%s' % tag)
		elem.text = str(int(round(int(elem.text) * s)))
		#print elem.text

	#Floating point tags that will decrease
	taglist = ['ROWUNCERTAINTY', 'COLUNCERTAINTY']
	for tag in taglist:
		elem = tree.find('.//%s' % tag)
		elem.text = str("%0.15e" % (float(elem.text) * s))
		#print elem.text

	#Floating point tags that will increase
    #Note: encountered problematic DG xml file that did not contain PRODUCTGSD tags, used COLLECTEDGSD instead
    #taglist = ['DETPITCH', 'MEANCOLLECTEDROWGSD', 'MEANCOLLECTEDCOLGSD', 'MEANCOLLECTEDGSD']
	taglist = ['DETPITCH', 'MEANPRODUCTROWGSD', 'MEANPRODUCTCOLGSD', 'MEANPRODUCTGSD']
	for tag in taglist:
		elem = tree.find('.//%s' % tag)
		elem.text = str("%0.15e" % (float(elem.text) / s))
		#print elem.text

	#Average number of image lines exposed per second, this will decrease
	tag = 'AVGLINERATE'
	elem = tree.find('.//%s' % tag)
	AVGLINERATE_new = float(elem.text) * s
	elem.text = str("%0.15e" % AVGLINERATE_new)
	
	tag = 'EXPOSUREDURATION'
	elem = tree.find('.//%s' % tag)
	elem.text = str("%0.15e" % (1/AVGLINERATE_new))
	
	#Correct the first line time, which corresponds to CENTER of first line
	#TLCTIME and FIRSTLINETIME 
	#<TLCTIME>2011-02-08T18:18:10.703575Z</TLCTIME>
	tag = 'TLCTIME'
	elem = tree.find('.//%s' % tag)
	TLCTIME = datetime.strptime(elem.text, '%Y-%m-%dT%H:%M:%S.%fZ')
	TLCTIME_delta = timedelta(seconds=(1/AVGLINERATE_new)/2)
	TLCTIME_new = TLCTIME + TLCTIME_delta
	elem.text = str("%s" % TLCTIME_new.strftime('%Y-%m-%dT%H:%M:%S.%fZ'))

	tag = 'FIRSTLINETIME'
	elem = tree.find('.//%s' % tag)
	elem.text = str("%s" % TLCTIME_new.strftime('%Y-%m-%dT%H:%M:%S.%fZ'))

	#TLC tags - only want to modify row number for each TLCLIST item
	tag = 'TLCLIST'
	elem = tree.findall('.//%s' % tag)
	for e in elem:
		l = (e.text.split())
		l[0] = "%0.15e" % (float(l[0]) * s)
		#Note - TLCLIST time value is relative to TLCTIME, which we've already corrected, so no need here
		#l[1] = "%0.15e" % (float(l[1]) + AVGLINERATE_new/2)
		e.text = ' '.join(l) 

	#Optical distortion is not supported
	#Set optical distortion polyorder from -1 to 0
	tag = 'POLYORDER'
	elem = tree.find('.//%s' % tag)
	elem.text = '0'

	#Deal with TILESIZE?  Should only be relevant for Level1A files, with individual detector tiles
	#Deal with RPB offsets and coefficients?

	tree.write(xml_outfilename)

def imgscale(img_in, img_out, s):
    #Note, PIL doesn't play nicely with 16-bit geotiff
    #import Image
    #im = Image.open(img_in)
    #w = im.size[0]*s
    #h = im.size[1]*s
    #im.resize((w,h), Image.ANTIALIAS).save(img_out)

    print "Resampling %s by factor of %i" % (img_in, s)

    import gdal
    import subprocess 
    
    mode = "AVERAGE"

    src_ds = gdal.Open(img_in, gdal.GA_ReadOnly)
    src_ds.BuildOverviews(mode, [s])
    subprocess.call(['mv '+img_in+'.ovr '+img_out])
   
    #OpenCV approach
    #import cv
    #im = cv.LoadImageM(img_in)
    #dst = cv.CreateMat(im.rows / s, im.cols / s, cv.CV_32FC1)
    #cv.Resize(im, dst, interpolation=CV_INTER_AREA)
    #out = numpy.asarray(dst)

    #Don't need to bother with this if src_ds is opened as read-only, overviews placed in external .ovr geotiff file
    #ovr = src_ds.GetRasterBand(1).GetOverview(0)
    #format = "GTiff"
    #driver = gdal.GetDriverByName(format)
    #dst_ds = driver.Create(img_out, ovr.XSize, ovr.YSize, 1, ovr.DataType)
    #dst_ds = None

    #Other approach is to read band into array and use scipy signal processing utils, but this will likely be slower
    #import scipy
    #scipy.signal.decimate(src_ds.ReadAsArray(), s)

def main():

    if (len(sys.argv) != 4):
        print "Usage is '", sys.argv[0], "img.{tif,ntf} perc out.xml'"
        print "Where perc is percent reduction (e.g. 50)"
        print
        sys.exit(1)

    #Need to add input checks
    perc = float(sys.argv[2])
    
    src_filename = sys.argv[1]
    dst_filename = sys.argv[3]
    sub=100.0/perc
    
    #dst_filename = str(os.path.splitext(src_filename)[0])  + str(int(sub)) + '.tif';
    #print('Writing ' + dst_filename)
    

    #Originally, use scale factor from 0-1
    s = perc/100.0

    #Since adding the image scaling functionality, use integer scaling to avoid aliasing
    #Eventually implement upsampling, filtering and downsampling for arbitrary scaling factor
    s_int = int(round(1./s))
    s = 1./s_int

    xml_infilename = str(os.path.splitext(src_filename)[0])+'.xml'
    #xml_infilename = 'WV01_11JUN171532400-P1BS-1020010014597A00.xml'
    #xml_outfilename = str(os.path.splitext(xml_infilename)[0])+'_sub' + str(int(sub)) + '.xml'
    xml_outfilename = dst_filename
    print('Reading ' + xml_infilename)
    print('Writing ' + xml_outfilename)

    #Create a modified xml file
    scalexml(xml_infilename, xml_outfilename, s)

    #Downsample the image using GDAL overview method
    #imgscale(src_filename, dst_filename, s_int)

if __name__ == '__main__':
	main()

