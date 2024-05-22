# Makefile
# create master .bib bibliography file from many .b2 files


com=b,bib -link

.SUFFIXES:	.b2 .bib

.PRECIOUS:	.b2 .bib

dirb = ../bib
#dirb = ~/l/tex/biblio/bib
master = $(dirb)/master.bib
masterjf = $(dirb)/master-jf.bib

all:	$(master) $(masterjf)

bfiles = *.b2 */*.b2 */*/*.b2
$(master):	$(bfiles) $(dirb)/abbrev.bib $(dirb)/spie.txt
		$(com) $(bfiles) > $@
#		sleep 1s
		make check

bfilesjf = jf/*.b2
$(masterjf):	$(bfilesjf) $(dirb)/abbrev.bib $(dirb)/spie.txt
		$(com) $(bfilesjf) > $@

check:
	b,check *.b2 */*.b2 */*/*.b2
	@echo 
#	grep -e ' $' *

get:
	wc -l *get* | sort -r -n

iso:
	file * */* */*/* | perl -ne 'print if /utf/i'
	file * */* */*/* | perl -ne 'print if /iso/i'

abbrev:
	grep journal $(master) | grep '{{[a-z][a-z]'
	grep booktitle $(master) | grep '{{[a-z][a-z]'

in = phase,unwrap.b2
b:
	b,bib -b $(in) > t2
#	b,bib -b $(in) | more; exit
	bib,b2 t2 > t3
#	bib,b2 t2.bib | more
	diff $(in) t3

bm:
	b,bib -b *.b2 > t2
	bib,b2 t2 > t3
#	diff $(in) t3

utf:
	perl -ane '{ if(m/[[:^ascii:]]/) { print  } }' ../bib/master.bib

mrm-early:
	gr '\:\:[a-z][a-z][a-z] mrm '
