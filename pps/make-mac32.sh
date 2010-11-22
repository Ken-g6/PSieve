appname=ppsieve-x86-mac
appname_boinc=ppsieve-boinc-x86-mac
tpsappname=tpsieve-x86-mac
tpsappname_boinc=tpsieve-boinc-x86-mac

BOINC_DIR=../../../boinc/boinc-6.7.4
BOINC_API_DIR=$BOINC_DIR/api
BOINC_LIB_DIR=$BOINC_DIR/lib
BOINC_LOAD_LIBS="-I$BOINC_DIR -I$BOINC_LIB_DIR -I$BOINC_API_DIR -L$BOINC_DIR -L$BOINC_LIB_DIR -L$BOINC_API_DIR"

gcc-4.0 -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -DUSE_BOINC -m32 -march=prescott -mtune=prescott -I. -I.. -o $appname_boinc $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c factor_proth.c -lm -lpthread -lboinc_api -lboinc -lstdc++

gcc-4.0 -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -m32 -march=prescott -mtune=prescott -I. -I.. -o $appname ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c factor_proth.c -lm -lpthread

gcc-4.0 -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -DUSE_BOINC -DSEARCH_TWIN -m32 -march=prescott -mtune=prescott -I. -I.. -o $tpsappname_boinc $BOINC_LOAD_LIBS ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c factor_proth.c -lm -lpthread -lboinc_api -lboinc -lstdc++

gcc-4.0 -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4  -Wall -O3 -D_GNU_SOURCE -DNDEBUG -DSEARCH_TWIN -m32 -march=prescott -mtune=prescott -I. -I.. -o $tpsappname ../main.c ../sieve.c ../clock.c ../putil.c app.c app_thread_fun.c factor_proth.c -lm -lpthread

