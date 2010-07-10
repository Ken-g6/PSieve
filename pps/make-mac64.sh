appname=primegrid_ppsieve_1.00_x86_64-apple-darwin
BOINC_DIR=../../../boinc/boinc-6.7.4
BOINC_API_DIR=$BOINC_DIR/api
BOINC_LIB_DIR=$BOINC_DIR/lib
BOINC_LOAD_LIBS="-I$BOINC_DIR -I$BOINC_LIB_DIR -I$BOINC_API_DIR -L$BOINC_DIR -L$BOINC_LIB_DIR -L$BOINC_API_DIR"

gcc -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -DUSE_BOINC -m64 -march=k8 -mno-3dnow -mtune=core2 -I. -I.. -o $appname $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c -lm -lpthread -lboinc_api -lboinc -lstdc++
