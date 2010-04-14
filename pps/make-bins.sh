appname=ppsieve
cleanvars="-fomit-frame-pointer -s"
# To build the BOINC Linux 64 version, get and make BOINC from subversion.  Place its directory location below.
#BOINC_DIR=/downloads/distributed/boinc610/server_stable
#BOINC_DIR=../../ppsb/boinc
BOINC_API_DIR=$BOINC_DIR/api
BOINC_LIB_DIR=$BOINC_DIR/lib
arch=`uname -m`
if [ "$BOINC_DIR" != "" ] ; then
	BOINC_LOAD_LIBS="-I$BOINC_DIR -I$BOINC_LIB_DIR -I$BOINC_API_DIR -L$BOINC_DIR -L$BOINC_LIB_DIR -L$BOINC_API_DIR"
else
	BOINC_LOAD_LIBS=""
fi

if uname -a | grep " 2.6.28[^ ]* [^ a-zA-Z]*Ubuntu" > /dev/null ; then 
	kernel=2.6.15
	cleanvars="-fomit-frame-pointer -s -fno-stack-protector"
fi

# 32-bit Linux (BOINC or non-BOINC)
if [ "$kernel" != "" ] ; then export LD_ASSUME_KERNEL=$kernel ; fi
if [ "$1" != "boinc" ] ; then
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=pentium3 -I. -I.. -o $appname-x86-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -o $appname-x86-linux-sse2 ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
else
	if [ "$arch" == "i686" ] ; then
		echo Making i686 BOINC version.
		gcc $cleanvars -Wall -O3 -DUSE_BOINC -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -o $appname-boinc-x86-linux-sse2 $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread -lboinc_api -lboinc `g++ -print-file-name=libstdc++.a` -DAPP_GRAPHICS
	fi
fi
if [ "$kernel" != "" ] ; then unset LD_ASSUME_KERNEL ; fi

# Wine Win32 apps (non-BOINC)
if [ -f /multimedia/mingw/bin/gcc.exe -a "$1" != "boinc" ] ; then
	wine /multimedia/mingw/bin/gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=pentium3 -I. -I.. -s -o $appname-x86-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
	wine /multimedia/mingw/bin/gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -s -o $appname-x86-windows-sse2.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
fi

# 64-bit Linux (BOINC or non-BOINC)
if [ "$kernel" != "" ] ; then export LD_ASSUME_KERNEL=$kernel ; fi
if [ "$1" != "boinc" ] ; then
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -o $appname-x86_64-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
else
	if [ "$arch" == "x86_64" ] ; then
		echo Making x86_64 BOINC version.
		gcc $cleanvars -Wall -O3 -DNDEBUG -D_REENTRANT -DUSE_BOINC -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -o $appname-boinc-x86_64-linux $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread -lboinc_api -lboinc `g++ -print-file-name=libstdc++.a` -DAPP_GRAPHICS
	fi
fi
if [ "$kernel" != "" ] ; then unset LD_ASSUME_KERNEL ; fi
# Wine Win64 app (non-BOINC)
if [ -f /multimedia/mingw64/bin/x86_64-w64-mingw32-gcc.exe -a "$1" != "boinc" ] ; then
	wine /multimedia/mingw64/bin/x86_64-w64-mingw32-gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -s -o $appname-x86_64-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
fi
#
#rm -f $appname-$appver-bin.zip
#zip -9 $appname-$appver-bin.zip README.txt CHANGES.txt ppconfig.txt $appname-x86-linux $appname-x86-linux-sse2 $appname-x86_64-linux $appname-x86-windows.exe $appname-x86-windows-sse2.exe $appname-x86_64-windows.exe make-bins.sh make-bins.bat app.c app.h ../src-0.2.4.zip
