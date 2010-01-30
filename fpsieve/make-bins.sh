#
gcc -Wall -O2 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i586 -I. -I.. -s -o fpsieve-x86-linux ../main.c ../sieve.c ../clock.c ../util.c app.c have_sse2.S factorial4_x86.S factorial4_x86_sse2.S primorial4_x86.S primorial4_x86_sse2.S -lm -lpthread
#
i586-mingw32msvc-gcc -Wall -O2 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i586 -I. -I.. -s -o fpsieve-x86-windows.exe ../main.c ../sieve.c ../clock.c ../util.c app.c have_sse2.S factorial4_x86.S factorial4_x86_sse2.S primorial4_x86.S primorial4_x86_sse2.S -lm
#
gcc -Wall -O2 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o fpsieve-x86_64-linux ../main.c ../sieve.c ../clock.c ../util.c app.c factorial4_x86_64.S primorial4_x86_64.S -lm -lpthread
#
ssh coo "(cd `pwd`; x86_64-pc-mingw32-gcc -Wall -O2 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o fpsieve-x86_64-windows.exe ../main.c ../sieve.c ../clock.c ../util.c app.c factorial4_x86_64.S primorial4_x86_64.S -lm)"
#
rm -f fpsieve-0.2.4-bin.zip
zip -9 fpsieve-0.2.4-bin.zip README.txt CHANGES.txt fpconfig.txt fpsieve-x86-linux fpsieve-x86_64-linux fpsieve-x86-windows.exe fpsieve-x86_64-windows.exe
