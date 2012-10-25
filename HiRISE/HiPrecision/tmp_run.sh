#!/bin/bash

base=$HOME/projects/HiRISE/HiPrecision

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000898_1725; id='x'; f1='TRA_000898_1725_RED3-RED4.flat.tab'; f2='TRA_000898_1725_RED5-RED4.flat.tab'; f3='TRA_000898_1725_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000897_1275; id='x'; f1='TRA_000897_1275_RED3-RED4.flat.tab'; f2='TRA_000897_1275_RED5-RED4.flat.tab'; f3='TRA_000897_1275_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000896_2220; id='x'; f1='TRA_000896_2220_RED4-RED5.flat.tab'; f2='TRA_000896_2220_RED6-RED5.flat.tab'; f3='TRA_000896_2220_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000894_2475; id='x'; f1='TRA_000894_2475_RED3-RED4.flat.tab'; f2='TRA_000894_2475_RED5-RED4.flat.tab'; f3='TRA_000894_2475_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000883_2005; id='x'; f1='TRA_000883_2005_RED4-RED5.flat.tab'; f2='TRA_000883_2005_RED6-RED5.flat.tab'; f3='TRA_000883_2005_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000882_2705; id='x'; f1='TRA_000882_2705_RED3-RED4.flat.tab'; f2='TRA_000882_2705_RED5-RED4.flat.tab'; f3='TRA_000882_2705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000882_1595; id='x'; f1='TRA_000882_1595_RED4-RED5.flat.tab'; f2='TRA_000882_1595_RED6-RED5.flat.tab'; f3='TRA_000882_1595_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000881_2475; id='x'; f1='TRA_000881_2475_RED3-RED4.flat.tab'; f2='TRA_000881_2475_RED5-RED4.flat.tab'; f3='TRA_000881_2475_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000880_1905; id='x'; f1='TRA_000880_1905_RED4-RED5.flat.tab'; f2='TRA_000880_1905_RED6-RED5.flat.tab'; f3='TRA_000880_1905_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000879_1390; id='x'; f1='TRA_000879_1390_RED4-RED5.flat.tab'; f2='TRA_000879_1390_RED6-RED5.flat.tab'; f3='TRA_000879_1390_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000878_2660; id='x'; f1='TRA_000878_2660_RED4-RED5.flat.tab'; f2='TRA_000878_2660_RED6-RED5.flat.tab'; f3='TRA_000878_2660_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000878_1410; id='x'; f1='TRA_000878_1410_RED3-RED4.flat.tab'; f2='TRA_000878_1410_RED5-RED4.flat.tab'; f3='TRA_000878_1410_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000876_1715; id='x'; f1='TRA_000876_1715_RED3-RED4.flat.tab'; f2='TRA_000876_1715_RED5-RED4.flat.tab'; f3='TRA_000876_1715_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000875_1765; id='x'; f1='TRA_000875_1765_IR10-RED4.flat.tab'; f2='TRA_000875_1765_RED4-RED5.flat.tab'; f3='TRA_000875_1765_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000873_2015; id='x'; f1='TRA_000873_2015_RED4-RED5.flat.tab'; f2='TRA_000873_2015_RED6-RED5.flat.tab'; f3='TRA_000873_2015_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000873_1415; id='x'; f1='TRA_000873_1415_RED4-RED5.flat.tab'; f2='TRA_000873_1415_RED6-RED5.flat.tab'; f3='TRA_000873_1415_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000871_2215; id='x'; f1='TRA_000871_2215_RED4-RED5.flat.tab'; f2='TRA_000871_2215_RED6-RED5.flat.tab'; f3='TRA_000871_2215_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000870_1995; id='x'; f1='TRA_000870_1995_RED4-RED5.flat.tab'; f2='TRA_000870_1995_RED6-RED5.flat.tab'; f3='TRA_000870_1995_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000869_1605; id='x'; f1='TRA_000869_1605_RED4-RED5.flat.tab'; f2='TRA_000869_1605_RED6-RED5.flat.tab'; f3='TRA_000869_1605_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000867_1875; id='x'; f1='TRA_000867_1875_RED4-RED5.flat.tab'; f2='TRA_000867_1875_RED6-RED5.flat.tab'; f3='TRA_000867_1875_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000866_1950; id='x'; f1='TRA_000866_1950_RED4-RED5.flat.tab'; f2='TRA_000866_1950_RED6-RED5.flat.tab'; f3='TRA_000866_1950_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000866_1420; id='x'; f1='TRA_000866_1420_RED3-RED4.flat.tab'; f2='TRA_000866_1420_RED5-RED4.flat.tab'; f3='TRA_000866_1420_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000865_2615; id='x'; f1='TRA_000865_2615_RED4-RED5.flat.tab'; f2='TRA_000865_2615_RED6-RED5.flat.tab'; f3='TRA_000865_2615_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000865_1905; id='x'; f1='TRA_000865_1905_RED4-RED5.flat.tab'; f2='TRA_000865_1905_RED6-RED5.flat.tab'; f3='TRA_000865_1905_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000863_2640; id='x'; f1='TRA_000863_2640_RED3-RED4.flat.tab'; f2='TRA_000863_2640_RED5-RED4.flat.tab'; f3='TRA_000863_2640_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000862_1710; id='x'; f1='TRA_000862_1710_RED4-RED5.flat.tab'; f2='TRA_000862_1710_RED6-RED5.flat.tab'; f3='TRA_000862_1710_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000861_2940; id='x'; f1='TRA_000861_2940_RED3-RED4.flat.tab'; f2='TRA_000861_2940_RED5-RED4.flat.tab'; f3='TRA_000861_2940_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000861_2580; id='x'; f1='TRA_000861_2580_RED4-RED5.flat.tab'; f2='TRA_000861_2580_RED5-RED4.flat.tab'; f3='TRA_000861_2580_IR10-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000861_1530; id='x'; f1='TRA_000861_1530_RED3-RED4.flat.tab'; f2='TRA_000861_1530_RED5-RED4.flat.tab'; f3='TRA_000861_1530_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000860_2585; id='x'; f1='TRA_000860_2585_RED4-RED5.flat.tab'; f2='TRA_000860_2585_RED6-RED5.flat.tab'; f3='TRA_000860_2585_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000858_2630; id='x'; f1='TRA_000858_2630_RED4-RED5.flat.tab'; f2='TRA_000858_2630_RED6-RED5.flat.tab'; f3='TRA_000858_2630_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000856_2500; id='x'; f1='TRA_000856_2500_RED3-RED4.flat.tab'; f2='TRA_000856_2500_RED5-RED4.flat.tab'; f3='TRA_000856_2500_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000856_2265; id='x'; f1='TRA_000856_2265_RED4-RED5.flat.tab'; f2='TRA_000856_2265_RED6-RED5.flat.tab'; f3='TRA_000856_2265_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000854_1855; id='x'; f1='TRA_000854_1855_RED4-RED5.flat.tab'; f2='TRA_000854_1855_RED6-RED5.flat.tab'; f3='TRA_000854_1855_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000853_1900; id='x'; f1='TRA_000853_1900_RED3-RED4.flat.tab'; f2='TRA_000853_1900_RED5-RED4.flat.tab'; f3='TRA_000853_1900_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000853_1450; id='x'; f1='TRA_000853_1450_RED4-RED5.flat.tab'; f2='TRA_000853_1450_RED6-RED5.flat.tab'; f3='TRA_000853_1450_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000850_2640; id='x'; f1='TRA_000850_2640_RED4-RED5.flat.tab'; f2='TRA_000850_2640_RED6-RED5.flat.tab'; f3='TRA_000850_2640_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000849_1675; id='x'; f1='TRA_000849_1675_RED4-RED5.flat.tab'; f2='TRA_000849_1675_RED6-RED5.flat.tab'; f3='TRA_000849_1675_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000848_2890; id='x'; f1='TRA_000848_2890_RED4-RED5.flat.tab'; f2='TRA_000848_2890_RED6-RED5.flat.tab'; f3='TRA_000848_2890_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000847_2055; id='x'; f1='TRA_000847_2055_RED4-RED5.flat.tab'; f2='TRA_000847_2055_RED6-RED5.flat.tab'; f3='TRA_000847_2055_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000846_2475; id='x'; f1='TRA_000846_2475_RED3-RED4.flat.tab'; f2='TRA_000846_2475_RED5-RED4.flat.tab'; f3='TRA_000846_2475_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000845_2645; id='x'; f1='TRA_000845_2645_RED3-RED4.flat.tab'; f2='TRA_000845_2645_RED5-RED4.flat.tab'; f3='TRA_000845_2645_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000844_2145; id='x'; f1='TRA_000844_2145_RED4-RED5.flat.tab'; f2='TRA_000844_2145_RED6-RED5.flat.tab'; f3='TRA_000844_2145_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000841_2460; id='x'; f1='TRA_000841_2460_RED3-RED4.flat.tab'; f2='TRA_000841_2460_RED5-RED4.flat.tab'; f3='TRA_000841_2460_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000841_1300; id='x'; f1='TRA_000841_1300_RED3-RED4.flat.tab'; f2='TRA_000841_1300_RED5-RED4.flat.tab'; f3='TRA_000841_1300_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000840_2750; id='x'; f1='TRA_000840_2750_RED4-RED5.flat.tab'; f2='TRA_000840_2750_RED6-RED5.flat.tab'; f3='TRA_000840_2750_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000840_1810; id='x'; f1='TRA_000840_1810_RED4-RED5.flat.tab'; f2='TRA_000840_1810_RED6-RED5.flat.tab'; f3='TRA_000840_1810_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000836_1740; id='x'; f1='TRA_000836_1740_RED4-RED5.flat.tab'; f2='TRA_000836_1740_RED6-RED5.flat.tab'; f3='TRA_000836_1740_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000835_1670; id='x'; f1='TRA_000835_1670_RED4-RED5.flat.tab'; f2='TRA_000835_1670_RED6-RED5.flat.tab'; f3='TRA_000835_1670_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000834_1835; id='x'; f1='TRA_000834_1835_RED4-RED5.flat.tab'; f2='TRA_000834_1835_RED6-RED5.flat.tab'; f3='TRA_000834_1835_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000833_1800; id='x'; f1='TRA_000833_1800_RED4-RED5.flat.tab'; f2='TRA_000833_1800_RED6-RED5.flat.tab'; f3='TRA_000833_1800_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000832_2670; id='x'; f1='TRA_000832_2670_RED4-RED5.flat.tab'; f2='TRA_000832_2670_RED6-RED5.flat.tab'; f3='TRA_000832_2670_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000832_2220; id='x'; f1='TRA_000832_2220_RED3-RED4.flat.tab'; f2='TRA_000832_2220_RED5-RED4.flat.tab'; f3='TRA_000832_2220_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000831_2220; id='x'; f1='TRA_000831_2220_RED4-RED5.flat.tab'; f2='TRA_000831_2220_RED6-RED5.flat.tab'; f3='TRA_000831_2220_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000830_1440; id='x'; f1='TRA_000830_1440_RED3-RED4.flat.tab'; f2='TRA_000830_1440_RED5-RED4.flat.tab'; f3='TRA_000830_1440_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000828_2495; id='x'; f1='TRA_000828_2495_RED3-RED4.flat.tab'; f2='TRA_000828_2495_RED5-RED4.flat.tab'; f3='TRA_000828_2495_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000828_1805; id='x'; f1='TRA_000828_1805_RED4-RED5.flat.tab'; f2='TRA_000828_1805_RED6-RED5.flat.tab'; f3='TRA_000828_1805_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000827_1875; id='x'; f1='TRA_000827_1875_RED3-RED4.flat.tab'; f2='TRA_000827_1875_RED5-RED4.flat.tab'; f3='TRA_000827_1875_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000825_2665; id='x'; f1='TRA_000825_2665_RED4-RED5.flat.tab'; f2='TRA_000825_2665_RED6-RED5.flat.tab'; f3='TRA_000825_2665_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/TRA/ORB_000800_000899/TRA_000823_1720; id='x'; f1='TRA_000823_1720_RED4-RED5.flat.tab'; f2='TRA_000823_1720_RED6-RED5.flat.tab'; f3='TRA_000823_1720_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010800_010899/PSP_010894_2180; id='x'; f1='PSP_010894_2180_RED3-RED4.flat.tab'; f2='PSP_010894_2180_RED5-RED4.flat.tab'; f3='PSP_010894_2180_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010500_010599/PSP_010548_2675; id='x'; f1='PSP_010548_2675_RED3-RED4.flat.tab'; f2='PSP_010548_2675_RED5-RED4.flat.tab'; f3='PSP_010548_2675_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010400_010499/PSP_010486_1775; id='x'; f1='PSP_010486_1775_RED3-RED4.flat.tab'; f2='PSP_010486_1775_RED5-RED4.flat.tab'; f3='PSP_010486_1775_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010300_010399/PSP_010361_1955; id='x'; f1='PSP_010361_1955_RED3-RED4.flat.tab'; f2='PSP_010361_1955_RED5-RED4.flat.tab'; f3='PSP_010361_1955_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010300_010399/PSP_010341_1775; id='x'; f1='PSP_010341_1775_RED3-RED4.flat.tab'; f2='PSP_010341_1775_RED5-RED4.flat.tab'; f3='PSP_010341_1775_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010300_010399/PSP_010329_1525; id='x'; f1='PSP_010329_1525_RED3-RED4.flat.tab'; f2='PSP_010329_1525_RED5-RED4.flat.tab'; f3='PSP_010329_1525_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010300_010399/PSP_010324_2675; id='x'; f1='PSP_010324_2675_RED3-RED4.flat.tab'; f2='PSP_010324_2675_RED5-RED4.flat.tab'; f3='PSP_010324_2675_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010100_010199/PSP_010193_2580; id='x'; f1='PSP_010193_2580_IR10-RED4.flat.tab'; f2='PSP_010193_2580_RED5-RED4.flat.tab'; f3='PSP_010193_2580_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010100_010199/PSP_010188_2410; id='x'; f1='PSP_010188_2410_IR10-RED4.flat.tab'; f2='PSP_010188_2410_RED5-RED4.flat.tab'; f3='PSP_010188_2410_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010100_010199/PSP_010188_1650; id='x'; f1='PSP_010188_1650_RED4-RED5.flat.tab'; f2='PSP_010188_1650_RED6-RED5.flat.tab'; f3='PSP_010188_1650_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010100_010199/PSP_010126_2675; id='x'; f1='PSP_010126_2675_RED3-RED4.flat.tab'; f2='PSP_010126_2675_RED5-RED4.flat.tab'; f3='PSP_010126_2675_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010100_010199/PSP_010107_1705; id='x'; f1='PSP_010107_1705_RED3-RED4.flat.tab'; f2='PSP_010107_1705_RED5-RED4.flat.tab'; f3='PSP_010107_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010000_010099/PSP_010094_2975; id='x'; f1='PSP_010094_2975_RED3-RED4.flat.tab'; f2='PSP_010094_2975_RED5-RED4.flat.tab'; f3='PSP_010094_2975_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010000_010099/PSP_010073_2725; id='x'; f1='PSP_010073_2725_RED3-RED4.flat.tab'; f2='PSP_010073_2725_RED5-RED4.flat.tab'; f3='PSP_010073_2725_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010000_010099/PSP_010008_2630; id='x'; f1='PSP_010008_2630_RED3-RED4.flat.tab'; f2='PSP_010008_2630_RED5-RED4.flat.tab'; f3='PSP_010008_2630_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_010000_010099/PSP_010007_2725; id='x'; f1='PSP_010007_2725_RED3-RED4.flat.tab'; f2='PSP_010007_2725_RED5-RED4.flat.tab'; f3='PSP_010007_2725_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009900_009999/PSP_009969_2630; id='x'; f1='PSP_009969_2630_RED3-RED4.flat.tab'; f2='PSP_009969_2630_RED5-RED4.flat.tab'; f3='PSP_009969_2630_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009900_009999/PSP_009913_2635; id='x'; f1='PSP_009913_2635_RED3-RED4.flat.tab'; f2='PSP_009913_2635_RED5-RED4.flat.tab'; f3='PSP_009913_2635_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009600_009699/PSP_009675_2060; id='x'; f1='PSP_009675_2060_RED3-RED4.flat.tab'; f2='PSP_009675_2060_RED5-RED4.flat.tab'; f3='PSP_009675_2060_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009600_009699/PSP_009631_1650; id='x'; f1='PSP_009631_1650_RED3-RED4.flat.tab'; f2='PSP_009631_1650_RED5-RED4.flat.tab'; f3='PSP_009631_1650_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009500_009599/PSP_009592_1705; id='x'; f1='PSP_009592_1705_RED3-RED4.flat.tab'; f2='PSP_009592_1705_RED5-RED4.flat.tab'; f3='PSP_009592_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009500_009599/PSP_009588_2175; id='x'; f1='PSP_009588_2175_RED3-RED4.flat.tab'; f2='PSP_009588_2175_RED5-RED4.flat.tab'; f3='PSP_009588_2175_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009400_009499/PSP_009492_1280; id='x'; f1='PSP_009492_1280_RED3-RED4.flat.tab'; f2='PSP_009492_1280_RED5-RED4.flat.tab'; f3='PSP_009492_1280_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009400_009499/PSP_009474_1705; id='x'; f1='PSP_009474_1705_RED3-RED4.flat.tab'; f2='PSP_009474_1705_RED5-RED4.flat.tab'; f3='PSP_009474_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009300_009399/PSP_009380_1665; id='x'; f1='PSP_009380_1665_RED3-RED4.flat.tab'; f2='PSP_009380_1665_RED5-RED4.flat.tab'; f3='PSP_009380_1665_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009200_009299/PSP_009294_1750; id='x'; f1='PSP_009294_1750_RED3-RED4.flat.tab'; f2='PSP_009294_1750_RED5-RED4.flat.tab'; f3='PSP_009294_1750_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_009100_009199/PSP_009149_1750; id='x'; f1='PSP_009149_1750_RED3-RED4.flat.tab'; f2='PSP_009149_1750_RED5-RED4.flat.tab'; f3='PSP_009149_1750_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008900_008999/PSP_008958_1665; id='x'; f1='PSP_008958_1665_RED3-RED4.flat.tab'; f2='PSP_008958_1665_RED5-RED4.flat.tab'; f3='PSP_008958_1665_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008900_008999/PSP_008907_1710; id='x'; f1='PSP_008907_1710_RED3-RED4.flat.tab'; f2='PSP_008907_1710_RED5-RED4.flat.tab'; f3='PSP_008907_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008800_008899/PSP_008808_1830; id='x'; f1='PSP_008808_1830_RED3-RED4.flat.tab'; f2='PSP_008808_1830_RED5-RED4.flat.tab'; f3='PSP_008808_1830_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008500_008599/PSP_008563_1765; id='x'; f1='PSP_008563_1765_RED3-RED4.flat.tab'; f2='PSP_008563_1765_RED5-RED4.flat.tab'; f3='PSP_008563_1765_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008500_008599/PSP_008528_2060; id='x'; f1='PSP_008528_2060_RED3-RED4.flat.tab'; f2='PSP_008528_2060_RED5-RED4.flat.tab'; f3='PSP_008528_2060_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008400_008499/PSP_008469_2040; id='x'; f1='PSP_008469_2040_IR11-RED5.flat.tab'; f2='PSP_008469_2040_RED3-RED4.flat.tab'; f3='PSP_008469_2040_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008300_008399/PSP_008379_1700; id='x'; f1='PSP_008379_1700_RED3-RED4.flat.tab'; f2='PSP_008379_1700_RED5-RED4.flat.tab'; f3='PSP_008379_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008300_008399/PSP_008338_1525; id='x'; f1='PSP_008338_1525_RED3-RED4.flat.tab'; f2='PSP_008338_1525_RED5-RED4.flat.tab'; f3='PSP_008338_1525_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008100_008199/PSP_008109_1880; id='x'; f1='PSP_008109_1880_RED3-RED4.flat.tab'; f2='PSP_008109_1880_RED5-RED4.flat.tab'; f3='PSP_008109_1880_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_008100_008199/PSP_008109_1510; id='x'; f1='PSP_008109_1510_RED3-RED4.flat.tab'; f2='PSP_008109_1510_RED5-RED4.flat.tab'; f3='PSP_008109_1510_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007900_007999/PSP_007917_1650; id='x'; f1='PSP_007917_1650_RED3-RED4.flat.tab'; f2='PSP_007917_1650_RED5-RED4.flat.tab'; f3='PSP_007917_1650_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007800_007899/PSP_007882_2065; id='x'; f1='PSP_007882_2065_RED3-RED4.flat.tab'; f2='PSP_007882_2065_RED5-RED4.flat.tab'; f3='PSP_007882_2065_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007700_007799/PSP_007795_2175; id='x'; f1='PSP_007795_2175_RED3-RED4.flat.tab'; f2='PSP_007795_2175_RED5-RED4.flat.tab'; f3='PSP_007795_2175_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007700_007799/PSP_007733_1705; id='x'; f1='PSP_007733_1705_RED3-RED4.flat.tab'; f2='PSP_007733_1705_RED5-RED4.flat.tab'; f3='PSP_007733_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007700_007799/PSP_007727_1830; id='x'; f1='PSP_007727_1830_RED3-RED4.flat.tab'; f2='PSP_007727_1830_RED5-RED4.flat.tab'; f3='PSP_007727_1830_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007600_007699/PSP_007678_2050; id='x'; f1='PSP_007678_2050_IR11-RED5.flat.tab'; f2='PSP_007678_2050_RED3-RED4.flat.tab'; f3='PSP_007678_2050_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007600_007699/PSP_007671_2065; id='x'; f1='PSP_007671_2065_RED3-RED4.flat.tab'; f2='PSP_007671_2065_RED5-RED4.flat.tab'; f3='PSP_007671_2065_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007600_007699/PSP_007667_1700; id='x'; f1='PSP_007667_1700_RED3-RED4.flat.tab'; f2='PSP_007667_1700_RED5-RED4.flat.tab'; f3='PSP_007667_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007600_007699/PSP_007627_1765; id='x'; f1='PSP_007627_1765_RED3-RED4.flat.tab'; f2='PSP_007627_1765_RED5-RED4.flat.tab'; f3='PSP_007627_1765_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007500_007599/PSP_007556_2010; id='x'; f1='PSP_007556_2010_RED3-RED4.flat.tab'; f2='PSP_007556_2010_RED5-RED4.flat.tab'; f3='PSP_007556_2010_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007400_007499/PSP_007474_1745; id='x'; f1='PSP_007474_1745_RED3-RED4.flat.tab'; f2='PSP_007474_1745_RED5-RED4.flat.tab'; f3='PSP_007474_1745_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007400_007499/PSP_007470_1705; id='x'; f1='PSP_007470_1705_RED3-RED4.flat.tab'; f2='PSP_007470_1705_RED5-RED4.flat.tab'; f3='PSP_007470_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007400_007499/PSP_007443_1705; id='x'; f1='PSP_007443_1705_RED3-RED4.flat.tab'; f2='PSP_007443_1705_RED5-RED4.flat.tab'; f3='PSP_007443_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007300_007399/PSP_007377_1700; id='x'; f1='PSP_007377_1700_RED3-RED4.flat.tab'; f2='PSP_007377_1700_RED5-RED4.flat.tab'; f3='PSP_007377_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007300_007399/PSP_007341_2020; id='x'; f1='PSP_007341_2020_RED3-RED4.flat.tab'; f2='PSP_007341_2020_RED5-RED4.flat.tab'; f3='PSP_007341_2020_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007200_007299/PSP_007200_2005; id='x'; f1='PSP_007200_2005_RED3-RED4.flat.tab'; f2='PSP_007200_2005_RED5-RED4.flat.tab'; f3='PSP_007200_2005_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007100_007199/PSP_007124_1765; id='x'; f1='PSP_007124_1765_RED3-RED4.flat.tab'; f2='PSP_007124_1765_RED5-RED4.flat.tab'; f3='PSP_007124_1765_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007100_007199/PSP_007110_1325; id='x'; f1='PSP_007110_1325_RED3-RED4.flat.tab'; f2='PSP_007110_1325_RED5-RED4.flat.tab'; f3='PSP_007110_1325_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_007000_007099/PSP_007087_1700; id='x'; f1='PSP_007087_1700_RED3-RED4.flat.tab'; f2='PSP_007087_1700_RED5-RED4.flat.tab'; f3='PSP_007087_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006700_006799/PSP_006788_1955; id='x'; f1='PSP_006788_1955_RED3-RED4.flat.tab'; f2='PSP_006788_1955_RED5-RED4.flat.tab'; f3='PSP_006788_1955_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006700_006799/PSP_006784_2640; id='x'; f1='PSP_006784_2640_RED3-RED4.flat.tab'; f2='PSP_006784_2640_RED5-RED4.flat.tab'; f3='PSP_006784_2640_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006700_006799/PSP_006774_2020; id='x'; f1='PSP_006774_2020_RED3-RED4.flat.tab'; f2='PSP_006774_2020_RED5-RED4.flat.tab'; f3='PSP_006774_2020_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006600_006699/PSP_006683_1740; id='x'; f1='PSP_006683_1740_RED3-RED4.flat.tab'; f2='PSP_006683_1740_RED5-RED4.flat.tab'; f3='PSP_006683_1740_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006600_006699/PSP_006637_1590; id='x'; f1='PSP_006637_1590_RED3-RED4.flat.tab'; f2='PSP_006637_1590_RED5-RED4.flat.tab'; f3='PSP_006637_1590_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006600_006699/PSP_006633_2010; id='x'; f1='PSP_006633_2010_IR11-RED5.flat.tab'; f2='PSP_006633_2010_RED3-RED4.flat.tab'; f3='PSP_006633_2010_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006500_006599/PSP_006588_1615; id='x'; f1='PSP_006588_1615_RED3-RED4.flat.tab'; f2='PSP_006588_1615_RED5-RED4.flat.tab'; f3='PSP_006588_1615_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_006500_006599/PSP_006525_1795; id='x'; f1='PSP_006525_1795_RED3-RED4.flat.tab'; f2='PSP_006525_1795_RED5-RED4.flat.tab'; f3='PSP_006525_1795_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005900_005999/PSP_005913_1640; id='x'; f1='PSP_005913_1640_RED3-RED4.flat.tab'; f2='PSP_005913_1640_RED5-RED4.flat.tab'; f3='PSP_005913_1640_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005900_005999/PSP_005903_1965; id='x'; f1='PSP_005903_1965_RED4-RED5.flat.tab'; f2='PSP_005903_1965_RED6-RED5.flat.tab'; f3='PSP_005903_1965_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005800_005899/PSP_005890_1160; id='x'; f1='PSP_005890_1160_RED3-RED4.flat.tab'; f2='PSP_005890_1160_RED5-RED4.flat.tab'; f3='PSP_005890_1160_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005800_005899/PSP_005837_1965; id='x'; f1='PSP_005837_1965_RED3-RED4.flat.tab'; f2='PSP_005837_1965_RED5-RED4.flat.tab'; f3='PSP_005837_1965_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005700_005799/PSP_005771_2035; id='x'; f1='PSP_005771_2035_RED3-RED4.flat.tab'; f2='PSP_005771_2035_RED5-RED4.flat.tab'; f3='PSP_005771_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005600_005699/PSP_005684_1890; id='x'; f1='PSP_005684_1890_RED3-RED4.flat.tab'; f2='PSP_005684_1890_RED5-RED4.flat.tab'; f3='PSP_005684_1890_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005600_005699/PSP_005649_1710; id='x'; f1='PSP_005649_1710_RED3-RED4.flat.tab'; f2='PSP_005649_1710_RED5-RED4.flat.tab'; f3='PSP_005649_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005600_005699/PSP_005600_1160; id='x'; f1='PSP_005600_1160_RED3-RED4.flat.tab'; f2='PSP_005600_1160_RED5-RED4.flat.tab'; f3='PSP_005600_1160_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_005200_005299/PSP_005201_1640; id='x'; f1='PSP_005201_1640_RED3-RED4.flat.tab'; f2='PSP_005201_1640_RED5-RED4.flat.tab'; f3='PSP_005201_1640_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_004300_004399/PSP_004375_1815; id='x'; f1='PSP_004375_1815_BG12-RED4_5tol.flat.tab'; f2='PSP_004375_1815_BG12-RED4_7tol.flat.tab'; f3='PSP_004375_1815_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_004300_004399/PSP_004339_1890; id='x'; f1='PSP_004339_1890_RED3-RED4.flat.tab'; f2='PSP_004339_1890_RED5-RED4.flat.tab'; f3='PSP_004339_1890_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_004200_004299/PSP_004241_1910; id='x'; f1='PSP_004241_1910_RED3-RED4.flat.tab'; f2='PSP_004241_1910_RED5-RED4.flat.tab'; f3='PSP_004241_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_004000_004099/PSP_004077_1325; id='x'; f1='PSP_004077_1325_RED3-RED4.flat.tab'; f2='PSP_004077_1325_RED5-RED4.flat.tab'; f3='PSP_004077_1325_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_004000_004099/PSP_004052_2045; id='x'; f1='PSP_004052_2045_RED3-RED4.flat.tab'; f2='PSP_004052_2045_RED5-RED4.flat.tab'; f3='PSP_004052_2045_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003900_003999/PSP_003964_1910; id='x'; f1='PSP_003964_1910_RED3-RED4.flat.tab'; f2='PSP_003964_1910_RED5-RED4.flat.tab'; f3='PSP_003964_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003800_003899/PSP_003896_1740; id='x'; f1='PSP_003896_1740_RED3-RED4.flat.tab'; f2='PSP_003896_1740_RED5-RED4.flat.tab'; f3='PSP_003896_1740_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003800_003899/PSP_003874_1815; id='x'; f1='PSP_003874_1815_RED3-RED4.flat.tab'; f2='PSP_003874_1815_RED5-RED4.flat.tab'; f3='PSP_003874_1815_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003800_003899/PSP_003855_1275; id='x'; f1='PSP_003855_1275_RED3-RED4.flat.tab'; f2='PSP_003855_1275_RED5-RED4.flat.tab'; f3='PSP_003855_1275_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003800_003899/PSP_003800_1325; id='x'; f1='PSP_003800_1325_RED3-RED4.flat.tab'; f2='PSP_003800_1325_RED5-RED4.flat.tab'; f3='PSP_003800_1325_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003500_003599/PSP_003587_2015; id='x'; f1='PSP_003587_2015_RED3-RED4.flat.tab'; f2='PSP_003587_2015_RED5-RED4.flat.tab'; f3='PSP_003587_2015_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003500_003599/PSP_003572_1650; id='x'; f1='PSP_003572_1650_RED3-RED4.flat.tab'; f2='PSP_003572_1650_RED5-RED4.flat.tab'; f3='PSP_003572_1650_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003500_003599/PSP_003569_2035; id='x'; f1='PSP_003569_2035_RED3-RED4.flat.tab'; f2='PSP_003569_2035_RED5-RED4.flat.tab'; f3='PSP_003569_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003500_003599/PSP_003543_1910; id='x'; f1='PSP_003543_1910_RED3-RED4.flat.tab'; f2='PSP_003543_1910_RED5-RED4.flat.tab'; f3='PSP_003543_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003300_003399/PSP_003398_1910; id='x'; f1='PSP_003398_1910_RED3-RED4.flat.tab'; f2='PSP_003398_1910_RED5-RED4.flat.tab'; f3='PSP_003398_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_003000_003099/PSP_003086_2015; id='x'; f1='PSP_003086_2015_RED3-RED4.flat.tab'; f2='PSP_003086_2015_RED5-RED4.flat.tab'; f3='PSP_003086_2015_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002800_002899/PSP_002860_1650; id='x'; f1='PSP_002860_1650_RED3-RED4.flat.tab'; f2='PSP_002860_1650_RED5-RED4.flat.tab'; f3='PSP_002860_1650_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002800_002899/PSP_002841_1740; id='x'; f1='PSP_002841_1740_RED3-RED4.flat.tab'; f2='PSP_002841_1740_RED5-RED4.flat.tab'; f3='PSP_002841_1740_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002800_002899/PSP_002828_1700; id='x'; f1='PSP_002828_1700_RED3-RED4.flat.tab'; f2='PSP_002828_1700_RED5-RED4.flat.tab'; f3='PSP_002828_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002800_002899/PSP_002822_1830; id='x'; f1='PSP_002822_1830_RED3-RED4.flat.tab'; f2='PSP_002822_1830_RED5-RED4.flat.tab'; f3='PSP_002822_1830_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002800_002899/PSP_002812_1855; id='x'; f1='PSP_002812_1855_RED3-RED4.flat.tab'; f2='PSP_002812_1855_RED5-RED4.flat.tab'; f3='PSP_002812_1855_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002700_002799/PSP_002756_1830; id='x'; f1='PSP_002756_1830_RED3-RED4.flat.tab'; f2='PSP_002756_1830_RED5-RED4.flat.tab'; f3='PSP_002756_1830_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002600_002699/PSP_002646_2035; id='x'; f1='PSP_002646_2035_RED3-RED4.flat.tab'; f2='PSP_002646_2035_RED5-RED4.flat.tab'; f3='PSP_002646_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002500_002599/PSP_002580_2035; id='x'; f1='PSP_002580_2035_RED3-RED4.flat.tab'; f2='PSP_002580_2035_RED5-RED4.flat.tab'; f3='PSP_002580_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002300_002399/PSP_002391_1995; id='x'; f1='PSP_002391_1995_RED3-RED4.flat.tab'; f2='PSP_002391_1995_RED5-RED4.flat.tab'; f3='PSP_002391_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002100_002199/PSP_002162_2260; id='x'; f1='PSP_002162_2260_RED3-RED4.flat.tab'; f2='PSP_002162_2260_RED5-RED4.flat.tab'; f3='PSP_002162_2260_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002100_002199/PSP_002159_1920; id='x'; f1='PSP_002159_1920_RED3-RED4.flat.tab'; f2='PSP_002159_1920_RED5-RED4.flat.tab'; f3='PSP_002159_1920_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002100_002199/PSP_002158_2035; id='x'; f1='PSP_002158_2035_RED4-RED5.flat.tab'; f2='PSP_002158_2035_RED6-RED5.flat.tab'; f3='PSP_002158_2035_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002000_002099/PSP_002088_1530; id='x'; f1='PSP_002088_1530_RED3-RED4.flat.tab'; f2='PSP_002088_1530_RED5-RED4.flat.tab'; f3='PSP_002088_1530_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_002000_002099/PSP_002063_1735; id='x'; f1='PSP_002063_1735_RED3-RED4.flat.tab'; f2='PSP_002063_1735_RED5-RED4.flat.tab'; f3='PSP_002063_1735_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001900_001999/PSP_001984_1735; id='x'; f1='PSP_001984_1735_RED3-RED4.flat.tab'; f2='PSP_001984_1735_RED5-RED4.flat.tab'; f3='PSP_001984_1735_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001900_001999/PSP_001976_2280; id='x'; f1='PSP_001976_2280_RED3-RED4.flat.tab'; f2='PSP_001976_2280_RED5-RED4.flat.tab'; f3='PSP_001976_2280_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001900_001999/PSP_001918_1735; id='x'; f1='PSP_001918_1735_RED3-RED4.flat.tab'; f2='PSP_001918_1735_RED5-RED4.flat.tab'; f3='PSP_001918_1735_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001800_001899/PSP_001890_1995; id='x'; f1='PSP_001890_1995_RED3-RED4.flat.tab'; f2='PSP_001890_1995_RED5-RED4.flat.tab'; f3='PSP_001890_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001700_001799/PSP_001719_2025; id='x'; f1='PSP_001719_2025_RED3-RED4.flat.tab'; f2='PSP_001719_2025_RED5-RED4.flat.tab'; f3='PSP_001719_2025_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001600_001699/PSP_001641_1735; id='x'; f1='PSP_001641_1735_RED3-RED4.flat.tab'; f2='PSP_001641_1735_RED5-RED4.flat.tab'; f3='PSP_001641_1735_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001500_001599/PSP_001593_2635; id='x'; f1='PSP_001593_2635_RED4-RED5.flat.tab'; f2='PSP_001593_2635_RED6-RED5.flat.tab'; f3='PSP_001593_2635_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001500_001599/PSP_001540_1890; id='x'; f1='PSP_001540_1890_RED3-RED4.flat.tab'; f2='PSP_001540_1890_RED5-RED4.flat.tab'; f3='PSP_001540_1890_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001500_001599/PSP_001538_2035; id='x'; f1='PSP_001538_2035_RED4-RED5.flat.tab'; f2='PSP_001538_2035_RED6-RED5.flat.tab'; f3='PSP_001538_2035_IR11-RED5.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001500_001599/PSP_001521_2025; id='x'; f1='PSP_001521_2025_RED3-RED4.flat.tab'; f2='PSP_001521_2025_RED5-RED4.flat.tab'; f3='PSP_001521_2025_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/PSP/ORB_001400_001499/PSP_001468_1535; id='x'; f1='PSP_001468_1535_RED3-RED4.flat.tab'; f2='PSP_001468_1535_RED5-RED4.flat.tab'; f3='PSP_001468_1535_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_027600_027699/ESP_027664_2245; id='x'; f1='ESP_027664_2245_RED3-RED4.flat.tab'; f2='ESP_027664_2245_RED5-RED4.flat.tab'; f3='ESP_027664_2245_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_027600_027699/ESP_027638_1795; id='x'; f1='ESP_027638_1795_RED3-RED4.flat.tab'; f2='ESP_027638_1795_RED5-RED4.flat.tab'; f3='ESP_027638_1795_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_027400_027499/ESP_027404_1860; id='x'; f1='ESP_027404_1860_RED3-RED4.flat.tab'; f2='ESP_027404_1860_RED5-RED4.flat.tab'; f3='ESP_027404_1860_IR10-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025900_025999/ESP_025987_1945; id='x'; f1='ESP_025987_1945_RED3-RED4.flat.tab'; f2='ESP_025987_1945_RED5-RED4.flat.tab'; f3='ESP_025987_1945_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025400_025499/ESP_025427_1995; id='x'; f1='ESP_025427_1995_RED3-RED4.flat.tab'; f2='ESP_025427_1995_RED5-RED4.flat.tab'; f3='ESP_025427_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025300_025399/ESP_025368_1755; id='x'; f1='ESP_025368_1755_RED3-RED4.flat.tab'; f2='ESP_025368_1755_RED5-RED4.flat.tab'; f3='ESP_025368_1755_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025200_025299/ESP_025282_1995; id='x'; f1='ESP_025282_1995_RED3-RED4.flat.tab'; f2='ESP_025282_1995_RED5-RED4.flat.tab'; f3='ESP_025282_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025100_025199/ESP_025137_1995; id='x'; f1='ESP_025137_1995_RED3-RED4.flat.tab'; f2='ESP_025137_1995_RED5-RED4.flat.tab'; f3='ESP_025137_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_025000_025099/ESP_025071_1995; id='x'; f1='ESP_025071_1995_RED3-RED4.flat.tab'; f2='ESP_025071_1995_RED5-RED4.flat.tab'; f3='ESP_025071_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_024800_024899/ESP_024874_1710; id='x'; f1='ESP_024874_1710_RED3-RED4.flat.tab'; f2='ESP_024874_1710_RED5-RED4.flat.tab'; f3='ESP_024874_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_024300_024399/ESP_024388_1560; id='x'; f1='ESP_024388_1560_RED3-RED4.flat.tab'; f2='ESP_024388_1560_RED5-RED4.flat.tab'; f3='ESP_024388_1560_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_024100_024199/ESP_024102_1755; id='x'; f1='ESP_024102_1755_RED3-RED4.flat.tab'; f2='ESP_024102_1755_RED5-RED4.flat.tab'; f3='ESP_024102_1755_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_024000_024099/ESP_024082_1995; id='x'; f1='ESP_024082_1995_RED3-RED4.flat.tab'; f2='ESP_024082_1995_RED5-RED4.flat.tab'; f3='ESP_024082_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_023700_023799/ESP_023726_1995; id='x'; f1='ESP_023726_1995_RED3-RED4.flat.tab'; f2='ESP_023726_1995_RED5-RED4.flat.tab'; f3='ESP_023726_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_023500_023599/ESP_023581_1995; id='x'; f1='ESP_023581_1995_RED3-RED4.flat.tab'; f2='ESP_023581_1995_RED5-RED4.flat.tab'; f3='ESP_023581_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_023300_023399/ESP_023383_1590; id='x'; f1='ESP_023383_1590_RED3-RED4.flat.tab'; f2='ESP_023383_1590_RED5-RED4.flat.tab'; f3='ESP_023383_1590_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_023300_023399/ESP_023304_1995; id='x'; f1='ESP_023304_1995_RED3-RED4.flat.tab'; f2='ESP_023304_1995_RED5-RED4.flat.tab'; f3='ESP_023304_1995_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_023100_023199/ESP_023107_1710; id='x'; f1='ESP_023107_1710_RED3-RED4.flat.tab'; f2='ESP_023107_1710_RED5-RED4.flat.tab'; f3='ESP_023107_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_022400_022499/ESP_022436_1705; id='x'; f1='ESP_022436_1705_RED3-RED4.flat.tab'; f2='ESP_022436_1705_RED5-RED4.flat.tab'; f3='ESP_022436_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_021900_021999/ESP_021973_1710; id='x'; f1='ESP_021973_1710_RED3-RED4.flat.tab'; f2='ESP_021973_1710_RED5-RED4.flat.tab'; f3='ESP_021973_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_021700_021799/ESP_021748_1990; id='x'; f1='ESP_021748_1990_RED3-RED4.flat.tab'; f2='ESP_021748_1990_RED5-RED4.flat.tab'; f3='ESP_021748_1990_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_021600_021699/ESP_021603_1990; id='x'; f1='ESP_021603_1990_RED3-RED4.flat.tab'; f2='ESP_021603_1990_RED5-RED4.flat.tab'; f3='ESP_021603_1990_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_021500_021599/ESP_021551_1710; id='x'; f1='ESP_021551_1710_RED3-RED4.flat.tab'; f2='ESP_021551_1710_RED5-RED4.flat.tab'; f3='ESP_021551_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020500_020599/ESP_020575_1665; id='x'; f1='ESP_020575_1665_RED3-RED4.flat.tab'; f2='ESP_020575_1665_RED5-RED4.flat.tab'; f3='ESP_020575_1665_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020300_020399/ESP_020390_1555; id='x'; f1='ESP_020390_1555_RED3-RED4.flat.tab'; f2='ESP_020390_1555_RED5-RED4.flat.tab'; f3='ESP_020390_1555_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020300_020399/ESP_020352_1710; id='x'; f1='ESP_020352_1710_RED3-RED4.flat.tab'; f2='ESP_020352_1710_RED5-RED4.flat.tab'; f3='ESP_020352_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020000_020099/ESP_020075_1750; id='x'; f1='ESP_020075_1750_RED3-RED4.flat.tab'; f2='ESP_020075_1750_RED5-RED4.flat.tab'; f3='ESP_020075_1750_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020000_020099/ESP_020043_1975; id='x'; f1='ESP_020043_1975_RED3-RED4.flat.tab'; f2='ESP_020043_1975_RED5-RED4.flat.tab'; f3='ESP_020043_1975_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_020000_020099/ESP_020034_1560; id='x'; f1='ESP_020034_1560_RED3-RED4.flat.tab'; f2='ESP_020034_1560_RED5-RED4.flat.tab'; f3='ESP_020034_1560_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019900_019999/ESP_019988_1750; id='x'; f1='ESP_019988_1750_RED3-RED4.flat.tab'; f2='ESP_019988_1750_RED5-RED4.flat.tab'; f3='ESP_019988_1750_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019700_019799/ESP_019757_1560; id='x'; f1='ESP_019757_1560_RED3-RED4.flat.tab'; f2='ESP_019757_1560_RED5-RED4.flat.tab'; f3='ESP_019757_1560_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019700_019799/ESP_019719_1750; id='x'; f1='ESP_019719_1750_RED3-RED4.flat.tab'; f2='ESP_019719_1750_RED5-RED4.flat.tab'; f3='ESP_019719_1750_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019600_019699/ESP_019678_1535; id='x'; f1='ESP_019678_1535_RED3-RED4.flat.tab'; f2='ESP_019678_1535_RED5-RED4.flat.tab'; f3='ESP_019678_1535_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019600_019699/ESP_019652_1665; id='x'; f1='ESP_019652_1665_RED3-RED4.flat.tab'; f2='ESP_019652_1665_RED5-RED4.flat.tab'; f3='ESP_019652_1665_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019600_019699/ESP_019612_1535; id='x'; f1='ESP_019612_1535_RED3-RED4.flat.tab'; f2='ESP_019612_1535_RED5-RED4.flat.tab'; f3='ESP_019612_1535_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019500_019599/ESP_019508_1700; id='x'; f1='ESP_019508_1700_RED3-RED4.flat.tab'; f2='ESP_019508_1700_RED5-RED4.flat.tab'; f3='ESP_019508_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019200_019299/ESP_019256_1530; id='x'; f1='ESP_019256_1530_RED3-RED4.flat.tab'; f2='ESP_019256_1530_RED5-RED4.flat.tab'; f3='ESP_019256_1530_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019200_019299/ESP_019218_1710; id='x'; f1='ESP_019218_1710_RED3-RED4.flat.tab'; f2='ESP_019218_1710_RED5-RED4.flat.tab'; f3='ESP_019218_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_019100_019199/ESP_019143_2635; id='x'; f1='ESP_019143_2635_RED3-RED4.flat.tab'; f2='ESP_019143_2635_RED5-RED4.flat.tab'; f3='ESP_019143_2635_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018900_018999/ESP_018938_2520; id='x'; f1='ESP_018938_2520_RED3-RED4.flat.tab'; f2='ESP_018938_2520_RED5-RED4.flat.tab'; f3='ESP_018938_2520_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018900_018999/ESP_018910_2625; id='x'; f1='ESP_018910_2625_RED3-RED4.flat.tab'; f2='ESP_018910_2625_RED5-RED4.flat.tab'; f3='ESP_018910_2625_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018800_018899/ESP_018875_1700; id='x'; f1='ESP_018875_1700_RED3-RED4.flat.tab'; f2='ESP_018875_1700_RED5-RED4.flat.tab'; f3='ESP_018875_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018800_018899/ESP_018870_2625; id='x'; f1='ESP_018870_2625_RED3-RED4.flat.tab'; f2='ESP_018870_2625_RED5-RED4.flat.tab'; f3='ESP_018870_2625_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018800_018899/ESP_018846_1775; id='x'; f1='ESP_018846_1775_RED3-RED4.flat.tab'; f2='ESP_018846_1775_RED5-RED4.flat.tab'; f3='ESP_018846_1775_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018600_018699/ESP_018628_2620; id='x'; f1='ESP_018628_2620_RED3-RED4.flat.tab'; f2='ESP_018628_2620_RED5-RED4.flat.tab'; f3='ESP_018628_2620_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018600_018699/ESP_018626_2420; id='x'; f1='ESP_018626_2420_RED3-RED4.flat.tab'; f2='ESP_018626_2420_RED5-RED4.flat.tab'; f3='ESP_018626_2420_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018500_018599/ESP_018525_2565; id='x'; f1='ESP_018525_2565_RED3-RED4.flat.tab'; f2='ESP_018525_2565_RED5-RED4.flat.tab'; f3='ESP_018525_2565_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018000_018099/ESP_018039_1890; id='x'; f1='ESP_018039_1890_RED3-RED4.flat.tab'; f2='ESP_018039_1890_RED5-RED4.flat.tab'; f3='ESP_018039_1890_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_018000_018099/ESP_018011_2565; id='x'; f1='ESP_018011_2565_RED3-RED4.flat.tab'; f2='ESP_018011_2565_RED5-RED4.flat.tab'; f3='ESP_018011_2565_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_017800_017899/ESP_017833_1975; id='x'; f1='ESP_017833_1975_RED3-RED4.flat.tab'; f2='ESP_017833_1975_RED5-RED4.flat.tab'; f3='ESP_017833_1975_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_017800_017899/ESP_017807_1700; id='x'; f1='ESP_017807_1700_RED3-RED4.flat.tab'; f2='ESP_017807_1700_RED5-RED4.flat.tab'; f3='ESP_017807_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_017700_017799/ESP_017762_1890; id='x'; f1='ESP_017762_1890_RED3-RED4.flat.tab'; f2='ESP_017762_1890_RED5-RED4.flat.tab'; f3='ESP_017762_1890_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_017400_017499/ESP_017494_2350; id='x'; f1='ESP_017494_2350_RED3-RED4.flat.tab'; f2='ESP_017494_2350_RED5-RED4.flat.tab'; f3='ESP_017494_2350_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_017000_017099/ESP_017055_1975; id='x'; f1='ESP_017055_1975_RED3-RED4.flat.tab'; f2='ESP_017055_1975_RED5-RED4.flat.tab'; f3='ESP_017055_1975_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016900_016999/ESP_016954_2245; id='x'; f1='ESP_016954_2245_RED3-RED4.flat.tab'; f2='ESP_016954_2245_RED5-RED4.flat.tab'; f3='ESP_016954_2245_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016900_016999/ESP_016927_1430; id='x'; f1='ESP_016927_1430_RED3-RED4.flat.tab'; f2='ESP_016927_1430_RED5-RED4.flat.tab'; f3='ESP_016927_1430_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016800_016899/ESP_016846_2320; id='x'; f1='ESP_016846_2320_RED3-RED4.flat.tab'; f2='ESP_016846_2320_RED5-RED4.flat.tab'; f3='ESP_016846_2320_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016700_016799/ESP_016780_2315; id='x'; f1='ESP_016780_2315_RED3-RED4.flat.tab'; f2='ESP_016780_2315_RED5-RED4.flat.tab'; f3='ESP_016780_2315_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016700_016799/ESP_016714_2315; id='x'; f1='ESP_016714_2315_RED3-RED4.flat.tab'; f2='ESP_016714_2315_RED5-RED4.flat.tab'; f3='ESP_016714_2315_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016600_016699/ESP_016641_2500; id='x'; f1='ESP_016641_2500_RED3-RED4.flat.tab'; f2='ESP_016641_2500_RED5-RED4.flat.tab'; f3='ESP_016641_2500_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016500_016599/ESP_016569_2320; id='x'; f1='ESP_016569_2320_RED3-RED4.flat.tab'; f2='ESP_016569_2320_RED5-RED4.flat.tab'; f3='ESP_016569_2320_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016400_016499/ESP_016490_2315; id='x'; f1='ESP_016490_2315_RED3-RED4.flat.tab'; f2='ESP_016490_2315_RED5-RED4.flat.tab'; f3='ESP_016490_2315_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016300_016399/ESP_016383_1705; id='x'; f1='ESP_016383_1705_RED3-RED4.flat.tab'; f2='ESP_016383_1705_RED5-RED4.flat.tab'; f3='ESP_016383_1705_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016200_016299/ESP_016213_2315; id='x'; f1='ESP_016213_2315_RED3-RED4.flat.tab'; f2='ESP_016213_2315_RED5-RED4.flat.tab'; f3='ESP_016213_2315_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_016100_016199/ESP_016153_2005; id='x'; f1='ESP_016153_2005_RED3-RED4.flat.tab'; f2='ESP_016153_2005_RED5-RED4.flat.tab'; f3='ESP_016153_2005_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_014400_014499/ESP_014429_1940; id='x'; f1='ESP_014429_1940_RED3-RED4.flat.tab'; f2='ESP_014429_1940_RED5-RED4.flat.tab'; f3='ESP_014429_1940_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_014300_014399/ESP_014339_1710; id='x'; f1='ESP_014339_1710_RED3-RED4.flat.tab'; f2='ESP_014339_1710_RED5-RED4.flat.tab'; f3='ESP_014339_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_014100_014199/ESP_014157_2035; id='x'; f1='ESP_014157_2035_RED3-RED4.flat.tab'; f2='ESP_014157_2035_RED5-RED4.flat.tab'; f3='ESP_014157_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_013700_013799/ESP_013735_2035; id='x'; f1='ESP_013735_2035_RED3-RED4.flat.tab'; f2='ESP_013735_2035_RED5-RED4.flat.tab'; f3='ESP_013735_2035_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012900_012999/ESP_012939_1875; id='x'; f1='ESP_012939_1875_RED3-RED4.flat.tab'; f2='ESP_012939_1875_RED5-RED4.flat.tab'; f3='ESP_012939_1875_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012800_012899/ESP_012873_2045; id='x'; f1='ESP_012873_2045_RED3-RED4.flat.tab'; f2='ESP_012873_2045_RED5-RED4.flat.tab'; f3='ESP_012873_2045_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012700_012799/ESP_012794_1875; id='x'; f1='ESP_012794_1875_RED3-RED4.flat.tab'; f2='ESP_012794_1875_RED5-RED4.flat.tab'; f3='ESP_012794_1875_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012600_012699/ESP_012638_1700; id='x'; f1='ESP_012638_1700_RED3-RED4.flat.tab'; f2='ESP_012638_1700_RED5-RED4.flat.tab'; f3='ESP_012638_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012400_012499/ESP_012479_1710; id='x'; f1='ESP_012479_1710_RED3-RED4.flat.tab'; f2='ESP_012479_1710_RED5-RED4.flat.tab'; f3='ESP_012479_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012400_012499/ESP_012429_1910; id='x'; f1='ESP_012429_1910_RED3-RED4.flat.tab'; f2='ESP_012429_1910_RED5-RED4.flat.tab'; f3='ESP_012429_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012200_012299/ESP_012295_1730; id='x'; f1='ESP_012295_1730_RED3-RED4.flat.tab'; f2='ESP_012295_1730_RED5-RED4.flat.tab'; f3='ESP_012295_1730_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_012000_012099/ESP_012005_1700; id='x'; f1='ESP_012005_1700_RED3-RED4.flat.tab'; f2='ESP_012005_1700_RED5-RED4.flat.tab'; f3='ESP_012005_1700_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011800_011899/ESP_011844_1855; id='x'; f1='ESP_011844_1855_RED3-RED4.flat.tab'; f2='ESP_011844_1855_RED5-RED4.flat.tab'; f3='ESP_011844_1855_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011700_011799/ESP_011717_1910; id='x'; f1='ESP_011717_1910_RED3-RED4.flat.tab'; f2='ESP_011717_1910_RED5-RED4.flat.tab'; f3='ESP_011717_1910_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011500_011599/ESP_011572_1615; id='x'; f1='ESP_011572_1615_RED3-RED4.flat.tab'; f2='ESP_011572_1615_RED5-RED4.flat.tab'; f3='ESP_011572_1615_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011300_011399/ESP_011372_1730; id='x'; f1='ESP_011372_1730_RED3-RED4.flat.tab'; f2='ESP_011372_1730_RED5-RED4.flat.tab'; f3='ESP_011372_1730_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011300_011399/ESP_011350_0945; id='x'; f1='ESP_011350_0945_RED3-RED4.flat.tab'; f2='ESP_011350_0945_RED5-RED4.flat.tab'; f3='ESP_011350_0945_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011300_011399/ESP_011341_0980; id='x'; f1='ESP_011341_0980_RED3-RED4.flat.tab'; f2='ESP_011341_0980_RED5-RED4.flat.tab'; f3='ESP_011341_0980_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011300_011399/ESP_011337_2360; id='x'; f1='ESP_011337_2360_RED3-RED4.flat.tab'; f2='ESP_011337_2360_RED5-RED4.flat.tab'; f3='ESP_011337_2360_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011300_011399/ESP_011327_1980; id='x'; f1='ESP_011327_1980_RED3-RED4.flat.tab'; f2='ESP_011327_1980_RED5-RED4.flat.tab'; f3='ESP_011327_1980_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011200_011299/ESP_011293_1710; id='x'; f1='ESP_011293_1710_RED3-RED4.flat.tab'; f2='ESP_011293_1710_RED5-RED4.flat.tab'; f3='ESP_011293_1710_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011200_011299/ESP_011268_2485; id='x'; f1='ESP_011268_2485_RED3-RED4.flat.tab'; f2='ESP_011268_2485_RED5-RED4.flat.tab'; f3='ESP_011268_2485_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision/Data/ESP/ORB_011200_011299/ESP_011261_1960; id='x'; f1='ESP_011261_1960_RED3-RED4.flat.tab'; f2='ESP_011261_1960_RED5-RED4.flat.tab'; f3='ESP_011261_1960_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

pwd
cd /home/oalexan1/projects/HiRISE/HiPrecision; id='x'; f1='PSP_001521_2025_RED3-RED4.flat.tab'; f2='PSP_001521_2025_RED5-RED4.flat.tab'; f3='PSP_001521_2025_BG12-RED4.flat.tab';
$base/resolveJitter ./ $id 20 $f1 -1 $f2 -1 $f3 -1
max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt
echo ''

