#!/bin/perl -w
# author.pl
# subroutine for reformatting author names into my ".b" format
#	to .b:		J A Fessler  S E Cutler  J Raz
#
# from medline:	Fessler JA, Cutler SE, Raz, J
# from ieee:	Fessler, J.A.; Cutler S.; Raz, J.
# from inspec:	Fessler-JA; Cutler-SE; Raz-J
# from ?:	Jeffrey A. Fessler, Susan E. Cutler and J. Raz

# fix: this needs a test suite!

sub author {
	$_ = $_[0];
	local($first, $second, $last, $rest, $i1, $i2, $i3, $h1, $h2);
	local($out) = "";

	s/, Jr\.//g;	# strip all ", Jr."
	s/, III//g;	# strip ", III"
	s/, II//g;	# strip ", II"
	s/^[ 	]*//;	# eliminate leading whitespace
	s/[	 ]$//g;	# eliminate trailing whitespace

	s/\d,/,/g;	# eliminate numbers like JA Fessler1, ... from \thanks
	s/\d$//;

	#
	# single author forms
	# Fessler, J. A. (or J.A. or J A or J. or J or J-A or J.-A. or JAB)
	#
	if (/^[A-Z][a-z]+, [A-Z]\.?[ -]?[A-Z]?\.?[A-Z]?\.?\s*$/) {
		($last, $i1, $h1, $i2, $h2, $i3) =
			/(\w+), ([A-Z])\.?([ -]?)([A-Z]?)\.?([ -]?)\.?([A-Z]?)/;
		die "bug" unless defined($i1);
		$h1 = " " if (defined($h1) && $h1 eq "");
		$h2 = " " if (defined($h2) && $h2 eq "");
		$i1 = "$i1$h1$i2" if (defined($i2) && $i2 ne "");
		$i1 = "$i1$h2$i3" if (defined($i3) && $i3 ne "");
		$out = "$i1 $last";
		return $out;
	}

	#
	# JA Fessler, and SE Cutler
	#
	if (0 && /^[A-Z]+ [A-Z][a-z]+/) {
		while (/[A-Z]+ [A-Z][a-z]+/) {
			($first, $last, $_) = /([A-Z]+) ([A-Z][a-z]+)(.*)/;
			if ($first =~ /[A-Z][A-Z]/) {
				$first =~ s/(.)/$1 /;
			}
			die "bug" unless defined($last);
			$out = "$out  $first $last";
		}
		$out =~ s/  //;
		return $out;
	}

	#
	# multi-author forms
	#
	if (/;/) {
		@_ = split(/; /);
	} elsif (/, and /) {	# xxx, yyy, and zzz
		s/, and /, /g;
		@_ = split(/, /);
	} elsif (/[A-Z]\.[A-Z]\. [A-Z]/) {	# J.A. Fessler
		s/ and / /;
		s/\. / /g;
		s/\./ /g;
		@_ = split(/, /);
	} elsif (/[A-Z]\.,/) {		# Fessler, J., Cutler, S.
		s/ and / /;
		@_ = split(/\., /);
	} else { # xxx, yyy and zzz
		s/ and /, /;
		@_ = split(/, /);
	}
#	print "here it is `@_'\n";

	while ($_ = shift(@_)) {
		s/ Jr$//;	# strip "Jr"
		s/ $//g;	# strip tailing spaces
		s/;//g;		# strip semicolons

#		print "`$_'\n";

		#
		# Fessler, Jeffrey-Joe Allen-Bob
		#
		if (/\w+, [A-Z][a-z][A-Za-z\-]+ [A-Z][a-z][A-Za-z\-]+$/) {
			($last, $first, $middle) =
			/(\w+), ([A-Za-z\-]+) ([A-Za-z\-]+)$/;
			die "bad `$_'\n" unless defined $middle;
			$out = $out . "$first $middle $last  ";
		}

		#
		# Fessler, Jeffrey Allen
		#
		elsif (/\w+, [A-Z][a-z]+ [A-Z][a-z]+$/) {
			($last, $first, $middle) =
			/(\w+), ([A-Z][a-z]+) ([A-Z][a-z]+)$/;
			$out = $out . "$first $middle $last  ";
		}

		#
		# Fessler, Jeffrey A.
		# Fessler, Jeffrey A
		#
		elsif (/\w+, [A-Z][a-z]+ [A-Z]\.?$/) {
			($last, $first, $middle) = /(\w+), ([A-Z][a-z]+) ([A-Z])\.?/;
			$out = $out . "$first $middle $last  ";
		}

		#
		# Fessler, J. Allen
		# Fessler, J Allen
		#
		elsif (/\w+, [A-Z]\.? [A-Z][a-z]+$/) {
			($last, $first, $middle) = /(\w+), ([A-Z])\.? ([A-Z][a-z]+)/;
			$out = $out . "$first $middle $last  ";
		}

		#
		# Fessler, J-A
		# Fessler, J.-A.
		# Fessler J-A
		# Fessler J.-A.
		#
		elsif (/\w+,? [A-Z]\.?-[A-Z]\.?$/) {
			($last, $first, $middle) = /(\w+),? ([A-Z])\.?-([A-Z])/;
			$out = $out . "$first-$middle $last  ";
		}

		#
		# Fessler-JAB
		# Fessler-JA
		# Fessler-J
		#
		elsif (/-[A-Z][A-Z][A-Z]$/) {
			($last, $first, $middle, $other) =
				/(\w*)-([A-Z])([A-Z])([A-Z])/;
			$out = $out . "$first $middle $other $last  ";
		}
		elsif (/-[A-Z][A-Z]$/) {
			($last, $first, $middle) = /(\w*)-([A-Z])([A-Z])/;
			$out = $out . "$first $middle $last  ";
		}
		elsif (/-[A-Z]$/) {
			($last, $first) = /(\w*)-([A-Z])/;
			$out = $out . "$first $last  ";
		}

		#
		# Fessler, J.A.B.	(or J.A. or J.)
		# Fessler, J. A. B.	(or J. A.)
		#
		elsif (/[\w -]+, [A-Z]\. ?[A-Z]\. ?[A-Z]\.$/) {
			($last, $first, $middle, $other) =
				/([\w -]+), ([A-Z])\. ?([A-Z])\. ?([A-Z])\./;
			$out = $out . "$first $middle $other $last  ";
		}
		elsif (/[\w -]+, [A-Z]\. ?[A-Z]\.$/) {
			($last, $first, $middle) =
				/([\w -]+), ([A-Z])\. ?([A-Z])\./;
			$out = $out . "$first $middle $last  ";
		}
		elsif (/[\w -]+, [A-Z]\.$/) {
			($last, $first) = /([\w -]+), ([A-Z])\./;
			$out = $out . "$first $last  ";
		}

		#
		# Fessler, JA
		# Fessler, J
		# Fessler JA
		# Fessler J
		#
		elsif (/\w+,? [A-Z][A-Z]$/) {
			($last, $first, $middle) = /(\w+),? ([A-Z])([A-Z])/;
			$out = $out . "$first $middle $last  ";
		}
		elsif (/\w+,? [A-Z]$/) {
			($last, $first) = /(\w+),? ([A-Z])$/;
			$out = $out . "$first $last  ";
		}

		#
		# Fessler, Jeffrey
		#
		elsif (/\w+, [A-Z][\w-]+$/) {
			($last, $first) = /(\w+), ([A-Z][\w-]+)$/;
			$out = $out . "$first $last  ";
		}

		#
		# JA Fessler
		#
		elsif (/^[A-Z][A-Z]+ [A-Z][a-z]+/) {
			s/\s*(.)/$1 /;
			$out = $out . "$_  ";
		}

		#
		# Jeffrey A. Fessler
		# or anything else
		#

		else {
			s/ +$//;
			s/^ +//;
			s/\.//g;
			s/ *,$//;
			$out = $out . "$_  ";
		}
	}

	$out =~ s/\s+$//;	# trailing whitespace
	return $out;
}

1;	# i guess this is needed
