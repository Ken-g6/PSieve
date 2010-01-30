rem 
rem gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o tpsieve-x86-linux ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
rem gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=k8 -msse2 -I. -I.. -s -o tpsieve-x86-linux-sse2 ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
rem 
c:\mingw\bin\gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=pentium3 -I. -I.. -s -o %TEMP%\tpsieve-x86-windows.exe ..\main.c ..\sieve.c ..\clock.c ..\util.c app.c -lm
c:\mingw\bin\gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -s -o %TEMP%\tpsieve-x86-windows-sse2.exe ..\main.c ..\sieve.c ..\clock.c ..\util.c app.c -lm
rem 
rem gcc -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o tpsieve-x86_64-linux ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
rem 
m:\mingw64\bin\x86_64-w64-mingw32-gcc.exe -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m64 -march=k8 -mtune=core2 -I. -I.. -s -o %TEMP%\tpsieve-x86_64-windows.exe ..\main.c ..\sieve.c ..\clock.c ..\util.c app.c -lm
rem 
rem rm -f tpsieve-0.2.1-bin.zip
rem zip -9 tpsieve-0.2.1-bin.zip README.txt CHANGES.txt tpconfig.txt tpsieve-x86-linux tpsieve-x86_64-linux tpsieve-x86-windows.exe tpsieve-x86_64-windows.exe
