appname=ppsieve
apppath=pps
appver=`grep "APP_VERSION" app.h | sed -e 's/^[^"]*"//;s/".*$//'`
rm -f $appname-$appver-bin.zip $appname-$appver-src.zip
zip -9 $appname-$appver-bin.zip $appname-x86-linux $appname-x86_64-linux $appname-boinc-x86-linux $appname-boinc-x86_64-linux $appname-x86-windows.exe $appname-boinc-x86-windows.exe $appname-boinc-x86_64-windows.exe $appname-x86_64-windows.exe tpsieve-x86-linux tpsieve-x86_64-linux tpsieve-boinc-x86-linux tpsieve-boinc-x86_64-linux tpsieve-x86-windows.exe tpsieve-boinc-x86-windows.exe tpsieve-boinc-x86_64-windows.exe tpsieve-x86_64-windows.exe README.txt CHANGES.txt $appname.sh $appname.bat *config.txt license.txt
cd ..
zip -9 $apppath/$appname-$appver-src.zip Makefile *.txt *.[ch] $apppath/*.[chS] $apppath/README.txt $apppath/CHANGES.txt $apppath/*config.txt $apppath/make-*.*[ht] $apppath/$appname.sh $apppath/$appname.bat
