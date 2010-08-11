#!/bin/sh
if [ $# != 1 ] ; then echo "Usage: $0 tpsearch_program" ; exit ; fi
if [ "$1" = "all" ] ; then
	sh one_n_test.sh lmsieve-x86_64-linux
	sh one_n_test.sh lmsieve-x86-linux-sse2
	sh one_n_test.sh lmsieve-x86-linux
	exit
fi
if [ ! -x $1 ] ; then echo "Usage: $0 tpsearch_program" ; exit ; fi
if [ -f tpcheckpoint.txt ] ; then rm tpcheckpoint.txt ; fi
mv tpfactors.txt tpfactors.txt.bak
if killall boincmgr ; then sleep 1 ; fi
boinccmd --set_run_mode never
sleep 3
./$1 -i halfmil_1n_lm0.txt -p 5000000250 -P6000000340 -q
boinccmd --set_run_mode auto
if sort tpfactors.txt | cmp npgOK.txt - ; then
	echo Test OK
	mv tpfactors.txt.bak tpfactors.txt
else
	echo TEST INVALID!!!
	printf "See diff (y/n)? "
	read keyin
	if [ $keyin == 'y' ] ; then
		sort tpfactors.txt | diff onesortOK.txt - | less
	fi
	printf "\nKeep bad tpfactors.txt (y/n)? "
	read keyin
	if [ $keyin != 'y' ] ; then mv tpfactors.txt.bak tpfactors.txt ; fi
fi
