#!/usr/bin/env python

# findlitoverlaps.py - This program takes a list of LROC product IDs and performs some simple processing to determine if they have overlapping lit regions.
#
# Copyright (C) 2012 Ross A. Beyer

# Ross, make sure to 
# export DYLD_LIBRARY_PATH=/Users/rbeyer/opt/GDAL-1.6.0/lib:/opt/macports/lib

import csv, os, sys, subprocess
from string import Template

product_ids = set()
pairs = set()
job_pool = [];

def add_job( cmd, num_working_threads=4 ):
    if ( len(job_pool) >= num_working_threads):
        job_pool[0].wait();
        job_pool.pop(0);
    print cmd;
    job_pool.append( subprocess.Popen(cmd, shell=True) );

def wait_on_all_jobs():
    print "Waiting for jobs to finish";
    while len(job_pool) > 0:
        job_pool[0].wait();
        job_pool.pop(0);

def lronac2isis( img_files ):
    lroc2isis_cubs = []
    for img in img_files:
        # Expect to end in .IMG, change to end in .cub
        to_cub = os.path.splitext( os.path.basename(img) )[0] + '.cub'
        if( os.path.exists(to_cub) ):
            print to_cub + ' exists, skipping lronac2isis.'
        else:
            cmd = 'lronac2isis from= '+ img +' to= '+ to_cub
            add_job(cmd)
        lroc2isis_cubs.append( to_cub )
    wait_on_all_jobs()
    return lroc2isis_cubs

def lronaccal( cub_files, delete=False ):
    lronaccal_cubs = []
    for cub in cub_files:
        # Expect to end in .cub, change to end in .cal.cub
        to_cub = os.path.splitext(cub)[0] + '.cal.cub'
        if( os.path.exists(to_cub) ):
            print to_cub + ' exists, skipping lronaccal.'
        else:
            cmd = 'lronaccal from=  '+ cub +' to= '+ to_cub
            add_job(cmd)
        lronaccal_cubs.append( to_cub )
    wait_on_all_jobs()
    if( delete ):
        for cub in cub_files: os.remove( cub )
    return lronaccal_cubs

def spice( cub_files ):
    for cub in cub_files:
        cmd = 'spiceinit from= '+ cub
        add_job(cmd)
    wait_on_all_jobs()
    return

def cam2map( cub_files, delete=False ):
    map_cubs = []
    for cub in cub_files:
         # Expect to end in cal.cub, change to end in .map.cub
        to_cub = cub.replace('.cal.','.map.')
        if( os.path.exists(to_cub) ):
            print to_cub + ' exists, skipping cam2map.'
        else:
            cmd = 'cam2map from= '+ cub +' to= '+ to_cub +' map=resolve.map pixres= mpp resolution= 10'
            add_job( cmd )
        map_cubs.append( to_cub )
    wait_on_all_jobs()
    if( delete ):
        for cub in cub_files: os.remove( cub )
    return map_cubs

def automos( cub_files, to_cub, priority='ontop', delete=False ):
    if( os.path.exists( to_cub ) ):
        print to_cub + ' exists, skipping autmos.'
        return to_cub
    else:
        # make fromlist
        fromlist = 'fromlist_'+to_cub+'.txt'
        f = open( fromlist, 'w')
        for cub in cub_files: print >> f, cub
        f.close()
        cmd = 'automos fromlist= '+ fromlist +' mosaic= '+ to_cub +' matchbandbin= false priority= '+ priority
        add_job( cmd )
    wait_on_all_jobs()
    os.remove( fromlist )
    if( delete ):
        for cub in cub_files: os.remove( cub )
    return to_cub

#open file
with open(sys.argv[1], 'r') as csvfile:
    firstline = csvfile.readline()
    dialect = ''
    if( '|' in firstline ): 
        csv.register_dialect('psql', delimiter = '|', skipinitialspace=True )
        dialect = 'psql'
    elif( ',' in firstline ): 
        csv.register_dialect('comma', delimiter = ',', skipinitialspace=True )
        dialect = 'comma'
    else:
        csvfile.seek(0)
        dialect = csv.Sniffer().sniff(csvfile.read(1024))
    csvfile.seek(0)

    reader = csv.reader(csvfile, dialect)
    for row in reader:
        if len(row) == 1:
            if( row[0].startswith('M') ):
                product_ids.add( row[0].strip() )
        if len(row) >= 2:
            if( row[0].startswith('M') and row[1].startswith('M') ):
                one = row[0].strip()
                two = row[1].strip()

                product_ids.add( one )
                product_ids.add( two )

                t = one, two
                pairs.add( t )

# for each image, prepare the 'observation' image.
for pid in product_ids:
    # lronac2isis
    isised = lronac2isis( (pid+'LE.IMG', pid+'RE.IMG') )

    # lronaccal
    caled = lronaccal( isised )
    spice( caled )

    # cam2map (project and downsample)
    mapped = cam2map( caled )

    # automos to create an 'observation'
    mosaic = automos( mapped, pid+'mosaic.cub' )

    # stretch (to threshhold)
    stretched = mosaic.replace('.cub','.str.cub')
    if( os.path.exists(stretched) ):
        print stretched + ' exists, skipping stretch.'
    else:
        cmd = 'stretch from= '+mosaic+' to= '+stretched+' usepercentages= True pairs= \"0:0.0 90:0.0 91:1.0 100:1.0\"'
        print cmd
        subprocess.call(cmd, shell=True)

for t in pairs:
    # map2map the second to the first
    stretched = (t[0]+'mosaic.str.cub', t[1]+'mosaic.str.cub')
    m2m = stretched[1].replace('.cub','.m2m.cub')
    if( os.path.exists(m2m) ):
        print m2m + ' exists, skipping map2map.'
    else:
        cmd = 'map2map from= '+stretched[1]+' to= '+m2m+' map= '+ stretched[0]+' matchmap= true'
        print cmd
        subprocess.call(cmd, shell=True)

    # use Algebra to combine
    alg = t[0] +'_'+ t[1] +'.cub'
    if( os.path.exists(alg) ):
        print alg + ' exists, skipping algebra.'
    else:
        cmd = 'algebra from= '+stretched[0]+' from2= '+m2m+' to= '+alg+' operator= add'
        print cmd
        subprocess.call(cmd, shell=True)

    # run hist 
    hist = alg.replace('.cub','.hist')
    cmd = 'hist from= '+ alg +' to= '+ hist
    print cmd
    subprocess.call(cmd, shell=True)
    
    os.remove( m2m )
