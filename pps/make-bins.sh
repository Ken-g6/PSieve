appname=ppsieve
cleanvars="-s -static-libgcc -static"
gcc_is_new=`gcc --version | grep " 4\.[3-9]" | wc -l`
# To build the BOINC Linux 64 version, get and make BOINC from subversion.  Place its directory location below.
# Or get boinc-dev from synaptic and comment out any BOINC_DIR lines.
BOINC_DIR=/downloads/distributed/boinc610/server_stable
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
	cleanvars="$cleanvars -fno-stack-protector"
elif uname -a | grep " 2.6.24" > /dev/null ; then 
	kernel=2.6.8
	cleanvars="$cleanvars -fno-stack-protector"
fi

# 32-bit Linux (BOINC or non-BOINC)
if [ "$kernel" != "" ] ; then export LD_ASSUME_KERNEL=$kernel ; fi
if [ "$gcc_is_new" == "1" ] ; then
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -S -o app_thread_fun_sse2.S app_thread_fun.c
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i586 -mtune=pentium3 -I. -I.. -S -o app_thread_fun_nosse2.S app_thread_fun.c
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -c -o app_thread_fun_sse2.o app_thread_fun.c
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i586 -mtune=pentium3 -I. -I.. -c -o app_thread_fun_nosse2.o app_thread_fun.c
else
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -msse2 -I. -I.. -c -o app_thread_fun_sse2.o app_thread_fun_sse2.S
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i586 -I. -I.. -c -o app_thread_fun_nosse2.o app_thread_fun_nosse2.S
fi

if [ "$1" != "boinc" ] ; then
	echo Making i686 non-BOINC version.
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i586 -mtune=k8 -I. -I.. -o $appname-x86-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun_sse2.o app_thread_fun_nosse2.o -lm -lpthread
	#gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -o $appname-x86-linux-sse2 ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
else
	if [ "$arch" == "i686" ] ; then
		echo Making i686 BOINC version.
		gcc $cleanvars -Wall -O3 -DUSE_BOINC -DNDEBUG -D_REENTRANT -DAPP_GRAPHICS -m32 -march=i586 -mtune=k8 -I. -I.. -o $appname-boinc-x86-linux $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun_sse2.o app_thread_fun_nosse2.o -lboinc_api -lboinc `g++ -print-file-name=libstdc++.a` -lm -lpthread
	fi
fi
if [ "$kernel" != "" ] ; then unset LD_ASSUME_KERNEL ; fi

# Wine Win32 app (non-BOINC)
if [ -f /multimedia/mingw/bin/gcc.exe -a "$1" != "boinc" ] ; then
	echo Making i686 non-BOINC Windows version.
	rm *.o
	wine /multimedia/mingw/bin/gcc.exe -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -c -o app_thread_fun_sse2.o app_thread_fun.c
	wine /multimedia/mingw/bin/gcc.exe -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m32 -march=i586 -mtune=pentium3 -I. -I.. -c -o app_thread_fun_nosse2.o app_thread_fun.c
	wine /multimedia/mingw/bin/gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i586 -mtune=core2 -I. -I.. -s -o $appname-x86-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun_sse2.o app_thread_fun_nosse2.o -lm
	#wine /multimedia/mingw/bin/gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -s -o $appname-x86-windows-sse2.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
fi

# 64-bit Linux (BOINC or non-BOINC)
if [ "$kernel" != "" ] ; then export LD_ASSUME_KERNEL=$kernel ; fi
if [ "$gcc_is_new" == "1" ] ; then
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -S -o app_thread_fun-x86_64.S app_thread_fun.c
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -c -o app_thread_fun-x86_64.o app_thread_fun.c
else
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -I. -I.. -c -o app_thread_fun-x86_64.o app_thread_fun-x86_64.S
fi
if [ "$1" != "boinc" ] ; then
	echo Making x86_64 non-BOINC version.
	gcc -Wall -O3 $cleanvars -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -o $appname-x86_64-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun-x86_64.o -lm -lpthread
else
	if [ "$arch" == "x86_64" ] ; then
		echo Making x86_64 BOINC version.
		gcc $cleanvars -Wall -O3 -DNDEBUG -D_REENTRANT -DUSE_BOINC -DAPP_GRAPHICS -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -o $appname-boinc-x86_64-linux $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun-x86_64.o -lboinc_api -lboinc `g++ -print-file-name=libstdc++.a` -lm -lpthread
	fi
fi
if [ "$kernel" != "" ] ; then unset LD_ASSUME_KERNEL ; fi
# Wine Win64 app (non-BOINC)
if [ -f /multimedia/mingw64/bin/x86_64-w64-mingw32-gcc.exe -a "$1" != "boinc" ] ; then
	echo Making x86_64 non-BOINC Windows version.
	wine /multimedia/mingw64/bin/x86_64-w64-mingw32-gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -s -o $appname-x86_64-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c -lm
fi
