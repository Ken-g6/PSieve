appname=primegrid_ppsieve_1.00_i686-apple-darwin
BOINC_DIR=../../../boinc/boinc-6.7.4
BOINC_API_DIR=$BOINC_DIR/api
BOINC_LIB_DIR=$BOINC_DIR/lib
BOINC_LOAD_LIBS="-I$BOINC_DIR -I$BOINC_LIB_DIR -I$BOINC_API_DIR -L$BOINC_DIR -L$BOINC_LIB_DIR -L$BOINC_API_DIR"

gcc-4.0 -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -DUSE_BOINC -m32 -march=prescott -mtune=prescott -I. -I.. -o $appname $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c -lm -lpthread -lboinc_api -lboinc -lstdc++
