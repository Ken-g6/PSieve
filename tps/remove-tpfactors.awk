#!/usr/bin/awk -f
#
# remove-tpfactors.awk -- Geoffrey Reynolds, May 2009.
#
#
# Usage: remove-tpfactors.awk [FACTORSFILE ...] INFILE [INFILE ...] > OUTFILE 
#
# Copies INFILEs to OUTFILE, removing any terms with factors in FACTORSFILEs
#
# For use with tpsieve. INFILE and OUTFILE must not be the same file!
#
# Changes:
# 11 Jun 2009: Fix to allow mixed DOS/unix input file formats.
# 20 Aug 2009: Allow multiple INFILEs
#


#
# A factor line like
#
# 77000939129 | 1605081*2^333333+1
#
/^[0-9]+ \| / {
  if (sieve_started) {
    print "ERROR: All factors must precede first sieve file" >> "/dev/stderr";
    exit 1;
  }
  split($3,A,"[^0-9]+");
  k = A[1];
  b = A[2];
  n = A[3]+0;
  if (!B)
    B = b;
  else if (B != b) {
    print "ERROR: Factors must all have same base" >> "/dev/stderr";
    exit 2;
  }
  F[k,n] = $1;
  next;
}

#
# A sieve header line like:
#
# 1000000000:T:1:2:3
#
/^[0-9]+:T:/ {
  split($0,A,":");
    b = A[4];
    t = A[5]+0;
  if (b != B) {
    print "ERROR: Sieve file must have same base as factors" >> "/dev/stderr";
    exit 3;
  }
  if (t != 3) {
    print "ERROR: Wrong type of sieve file" >> "/dev/stderr";
    exit 3;
  }
  if (!sieve_started) {
    print;
    sieve_started = 1;
  }
}

#
# A sieve file line consisting of a k,n pair
#
/^[0-9]+ [0-9]+/ {
  if (!(($1,$2+0) in F))
    print;
}
