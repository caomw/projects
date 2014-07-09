BASE=/Users/oalexan1/projects/albedo/isis_package/

ISIS=$BASE/isis
DEPS=$BASE/isis_deps

rm -fv cam2map cam2map.o

g++ -I$ISIS/inc     -I$DEPS/ports/share/qt4/mkspecs/macx-g++ -I$DEPS/ports/lib/QtCore.framework/Headers -I$DEPS/ports/lib/QtAssistant.framework/Headers -I$DEPS/ports/lib/QtGui.framework/Headers -I$DEPS/ports/lib/QtNetwork.framework/Headers -I$DEPS/ports/lib/QtOpenGL.framework/Headers -I$DEPS/ports/lib/QtScript.framework/Headers -I$DEPS/ports/lib/QtScriptTools.framework/Headers -I$DEPS/ports/lib/QtSql.framework/Headers -I$DEPS/ports/lib/QtSvg.framework/Headers -I$DEPS/ports/lib/QtTest.framework/Headers -I$DEPS/ports/lib/QtWebKit.framework/Headers -I$DEPS/ports/lib/QtXml.framework/Headers -I$DEPS/ports/lib/QtXmlPatterns.framework/Headers -F$DEPS/ports/lib  -I$DEPS/ports/lib/qwt.framework/Headers  -I$DEPS/ports/include/xercesc  -I$DEPS/ports/include/tiff  -I$DEPS/3rdparty/include  -I$DEPS/3rdparty/include/tnt  -I$DEPS/3rdparty/include/jama -I$DEPS/ports/include/geos -I$DEPS/ports/include/gsl -I$DEPS/3rdparty/include -I$DEPS/ports/include/google -I$DEPS/ports/include -I$DEPS/proprietary/include/kakadu/v6_3-00967N -I$DEPS/3rdparty/include -I$DEPS/3rdparty/include/superlu -Wall -ansi -arch x86_64 -Xarch_x86_64 -mmacosx-version-min=10.6 -DISIS_LITTLE_ENDIAN=1 -D_LARGEFILE64_SOURCE -D_LARGEFILE_SOURCE -fPIC -DGMM_USES_SUPERLU -O1 -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED -DENABLEJP2K=0  -c -o cam2map.o cam2map.cpp

g++ -L. -L$ISIS/lib -L$DEPS/ports/lib -F$DEPS/ports/lib -L$DEPS/ports/lib -F$DEPS/ports/lib -L$DEPS/ports/lib -L$DEPS/ports/lib -L$DEPS/3rdparty/lib -L$DEPS/ports/lib -L$DEPS/ports/lib -L$DEPS/ports/lib -L$DEPS/ports/lib -L$DEPS/proprietary/lib -L$DEPS/3rdparty/lib -L$DEPS/3rdparty/lib -headerpad_max_install_names -arch x86_64 -Xarch_x86_64 -mmacosx-version-min=10.6 -bind_at_load -Wl,-w -Wl,-rpath,@loader_path/.. -Wl,-rpath,$ISIS -o cam2map cam2map.o -lisis3.4.6 -lz -lm -framework ApplicationServices -framework QtXmlPatterns -framework QtXml -framework QtNetwork -framework QtSql -framework QtGui -framework QtCore -framework QtSvg -framework QtTest -framework QtWebKit -framework QtOpenGL -framework qwt -lxerces-c -ltiff -lcspice -lgeos -lgsl -lgslcblas -lprotobuf -lkdu_a63R -lcholmod -lamd -lcolamd -framework Accelerate -lsuperlu -lblas


$ISIS/scripts/SetRunTimePath --bins --libmap=$ISIS/scripts/isis_bins_paths.lis --liblog=$ISIS/scripts/DarwinLibs.lis --relocdir=$ISIS/3rdParty/lib:$ISIS/3rdParty:$ISIS --errlog=DarwinErrors.lis cam2map

export ISISROOT=$ISIS
export ISIS3DATA=$HOME/projects/isis3data
export DYLD_FALLBACK_LIBRARY_PATH=$ISIS/3rdParty/lib

$ISISROOT/bin/spiceinit from=$BASE/AS15-M-0587.lev1.cub

./cam2map from=$BASE/AS15-M-0587.lev1.cub to=mapped.cub pixres=mpp resolution=100

