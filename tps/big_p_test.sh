#!/bin/bash
resume_boinc()
# Resume BOINC if it's been stopped.  (Just continues otherwise.)
{
	boinccmd --set_run_mode auto
}

if [ $# != 1 ] ; then echo "Usage: $0 tpsearch_program" ; exit ; fi
if [ "$1" = "all" ] ; then
	sh big_p_test.sh tpsieve-x86_64-linux
	sh big_p_test.sh tpsieve-x86-linux-sse2
	sh big_p_test.sh tpsieve-x86-linux
	exit
fi
if [ ! -x $1 ] ; then echo "Usage: $0 tpsearch_program" ; exit ; fi
if [ -f tpcheckpoint.txt ] ; then rm tpcheckpoint.txt ; fi
mv tpfactors.txt tpfactors.txt.bak
if killall boincmgr ; then sleep 1 ; fi
boinccmd --set_run_mode never
# trap keyboard interrupt (control-c)
#trap resume_boinc SIGINT
sleep 3
taskset 0x00000002 ./$1 -i n487000half.txt -N 487999 -p 5T -q #| grep -v '|'
resume_boinc
if grep '|' tpfactors.txt | sort | cmp OKsortbig.txt - ; then
	echo Test OK
	mv tpfactors.txt.bak tpfactors.txt
else
	echo TEST INVALID!!!
	printf "See diff (y/n)? "
	read keyin
	if [ $keyin == 'y' ] ; then
		sort tpfactors.txt | diff OKsortbig.txt - | less
	fi
	printf "\nKeep bad tpfactors.txt (y/n)? "
	read keyin
	if [ $keyin != 'y' ] ; then mv tpfactors.txt.bak tpfactors.txt ; fi
fi
