#!/bin/perl -w
# author.pl
# subroutine for reformatting author names into my ".b" format
# to .b:	J A Fessler  S E Cutler  J Raz
#
# from medline:	Fessler JA, Cutler SE, Raz, J
# from ieee:	Fessler, J.A.; Cutler S.; Raz, J.
# from inspec:	Fessler-JA; Cutler-SE; Raz-J
# from ?:	Jeffrey A. Fessler, Susan E. Cutler and J. Raz
# from ?:	Fessler J A; Cutler S E

# This problem is ill-posed: "De Man, Bruno Bob" vs "Jeff Fessler, Sue Cutler"
# We resolve this ambiguity by assuming the second form, since spaces in names
# are less common.  Of course "De Man, B C" and "De Man, Bruno" are unambiguous.

# from man perlretut
use charnames ":full"; # use named chars with Unicode full names

#
# process a (possibly) single-author form
# returns (0|1, string) where 1 indicates success
#
sub do_author1
{
	$_ = $_[0];
	my $only1 = $_[1]; # 1 if sure that this is only 1 name, else 0

	if ($only1 && /^[^,]+, [^,]+$/) # last, first
	{
		($last, $first) = /^([^,]+), ([^,]+)$/;
		die "bug" unless defined($first);
		# braces for last name if spaces and not yet braces
		$last = "\{$last\}" if ($last =~ m/\s/ && $last !~ m/[\{\}]/);
		return (1, "$first $last");
	}

	# Initials: J or JA or JAB or J.A. or J. A. or J-A or J.-A. etc.
	# matches: init1 sep1 init2 init3
	my $init3 = qr/([A-Z])\.?([ -])?([A-Z])?\.? ?([A-Z])?\.?/;

	# initials then last name
	# B De Man
	if ($only1 && /^$init3 (.*)$/)
	{
		$_ = "$1"; # first initial
		my $sep = " ";
		$sep = $2 if defined($2); # space or hyphen
		$_ = $_ . $sep . $3 if defined($3);
		$_ = "$_ $4" if defined($4);
		my $last = $5;
		$last = "\{$last\}" if ($last =~ m/\s/ && $last !~ m/[\{\}]/); # braces if spaces and not yet braces
		return (1, "$_ $last");
	}

	#
	# single author with initials.
	# here the comma is optional so last name cannot have spaces
	# Fessler-Cutler, $init3
	# Fessler-Cutler $init3
	# Fessler-Cutler-$init3
	#
	if (/^([^\s\,]+)(,? |\-)$init3$/)
	{
		$_ = "$3"; # first initial
		my $sep = " ";
		$sep = $4 if defined($4); # space or hyphen
		$_ = $_ . $sep . $5 if defined($5);
		$_ = "$_ $6" if defined($6);
		return (1, "$_ $1");
	}

	# as above, but allow space in last name
	# De Man B
	if ($only1 && /^([^\,]*),? $init3$/)
	{
		$_ = "$2"; # first initial
		my $sep = " ";
		$sep = $3 if defined($3); # space or hyphen
		$_ = $_ . $sep . $4 if defined($4);
		$_ = "$_ $5" if defined($5);
		my $last = $1;
		$last = "\{$last\}" if ($last =~ m/\s/); # braces if spaces
		return (1, "$_ $last");
	}

	#
	# single author with initials.
	# here the comma is required so last name *can* have spaces
	# De Man, $init3
	#
	if (/^([^\,]+), $init3$/)
	{
		$_ = "$2"; # first initial
		my $sep = " ";
		$sep = $3 if defined($3); # space or hyphen
		$_ = $_ . $sep . $4 if defined($4);
		$_ = "$_ $5" if defined($5);
		my $last = $1;
		$last = "\{$last\}" if ($last =~ m/\s/); # braces if spaces
		return (1, "$_ $last");
	}

	#
	# single author with first/middle name.
	# here the comma is required and the last name cannot have spaces
	# due to the ambiguity above.
	# first and middle name cannot have space or comma within
	# Fessler, Jeff
	# Fessler, Jeffrey A
	# Fessler, Jeffrey A.
	# Fessler, J Allen
	# Fessler, J. Allen
	#
	my $first = qr/[A-Z]\.|[^\s\,]+/;
	if (/^([^\s\,]+), ($first)( $first)?$/)
	{
		$_ = "$2";
		$_ = "$_ $3" if defined($3);
		$_ = "$_ $1";
		s/\s+/ /g;
		s/\.//g;
		return (1, "$_");
	}

	# return original string if no matches
	return (0, $_);
}


sub old_do_author1
{
	$_ = $_[0];

	# last name starts with an upper, has no spaces, and ends with a lower.
	# it can have upper in middle, like McCoy
	# the following makes that a compiled regexp
#	$Last = qr/[A-Z]\p{IsLower}+/;
#	my $Last = qr/\p{IsUpper}\S*\p{IsLower}/;

	# first "name" can be just an upper initial J or Jeff or Jeff-Bob
#	my $First = qr/\p{IsUpper}\p{IsLower}*|\p{IsUpper}\p{IsLower}+\-\p{IsUpper}\p{IsLower}+/;

	#
	# Fessler, J. A. B.
	# Fessler, J.A.B.
	# Fessler, JAB
	#
	if (/($Last),? ([A-Z])\.? ?[A-Z]\.? ?([A-Z])\.$/) {
		$out = $out . "$2 $3 $4 $1  ";
	}
	elsif (0 && /[\w -]+, [A-Z]\. ?[A-Z]\. ?[A-Z]\.$/) {
		($last, $first, $middle, $other) =
			/([\w -]+), ([A-Z])\. ?([A-Z])\. ?([A-Z])\./;
		$out = $out . "$first $middle $other $last  ";
	}
	elsif (0 && /[\w -]+, [A-Z]\. ?[A-Z]\.$/) {
		($last, $first, $middle) =
			/([\w -]+), ([A-Z])\. ?([A-Z])\./;
		$out = $out . "$first $middle $last  ";
	}
	elsif (0 && /[\w -]+, [A-Z]\.$/) {
		($last, $first) = /([\w -]+), ([A-Z])\./;
		$out = $out . "$first $last  ";
	}

	#
	# Fessler, Jeffrey Allen
	# Fessler, Jeffrey-Joe Allen-Bob
	# Fessler, Jeffrey A.
	# Fessler, Jeffrey A
	# Fessler, J. Allen
	# Fessler, J Allen
	# Fessler, J. A.
	# Fessler, J A
	#
	if (/($Last), ($First)\.? ($First)\.?$/) {
		$out = $out . "$2 $3 $1  ";
	}

	#
	# Fessler, JA
	# Fessler JA
	# Fessler J A
	#
	elsif (/($Last),? ([A-Z]) ?([A-Z])$/) {
		$out = $out . "$2 $3 $1  ";
	}
	elsif (0 && /$Last,? [A-Z] ?[A-Z]$/) {
		($last, $first, $middle) = /($Last),? ([A-Z]) ?([A-Z])/;
		$out = $out . "$first $middle $last  ";
	}

	#
	# Fessler, Jeffrey-Joe Allen-Bob
	#
	elsif (0 && /$Last, [A-Z][a-z][A-Za-z\-]+ [A-Z][a-z][A-Za-z\-]+$/) {
		($last, $first, $middle) =
		/($Last), ([A-Za-z\-]+) ([A-Za-z\-]+)$/;
		die "bad `$_'\n" unless defined $middle;
		$out = $out . "$first $middle $last  ";
	}

	#
	# Fessler, Jeffrey A.
	# Fessler, Jeffrey A
	#
	elsif (0 && /$Last, $Last [A-Z]\.?$/) {
		($last, $first, $middle) = /($Last), ($Last) ([A-Z])\.?/;
		$out = $out . "$first $middle $last  ";
	}

	#
	# Fessler, J. Allen
	# Fessler, J Allen
	#
	elsif (0 && /$Last, [A-Z]\.? $Last$/) {
		($last, $first, $middle) = /($Last), ([A-Z])\.? ($Last)/;
		$out = $out . "$first $middle $last  ";
	}

	#
	# Fessler, J-A
	# Fessler, J.-A.
	# Fessler J-A
	# Fessler J.-A.
	#
	elsif (/$Last,? [A-Z]\.?-[A-Z]\.?$/) {
		($last, $first, $middle) = /($Last),? ([A-Z])\.?-([A-Z])/;
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

	# Fessler, J
	# Fessler J
	elsif (/$Last,? [A-Z]$/) {
		($last, $first) = /($Last),? ([A-Z])$/;
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
	elsif (/^[A-Z][A-Z]+ $Last/) {
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


sub author
{
	$_ = $_[0];
	my ($first, $second, $last, $rest);
	my $out = "";

	s/, Jr\.//g;	# cut ", Jr."
	s/, Sr\.//g;	# cut ", Sr."
	s/,? ?III//g;	# cut III
	s/,? ?II//g;	# cut II
	s/^\s*//;	# cut leading whitespace
	s/\s*$//;	# cut trailing whitespace

	s/\d//g;	# cut numbers as in JA Fessler1, ... from \thanks
	s/\s+,/,/g;	# cut space before comma
	s/\s+ and / and /g; # cut extra space(s) before " and "

	# single author of the form "last, first"
	# only a single "," and only a single last name before it with no spaces
	if (/^[\w\-]+, [^,]+$/)
	{
		($last, $first) = /^([\w\-]+), ([^,]+)$/;
		die "bug" unless defined($first);
		return "$first $last";
	}

	# single author of the form De Man, Bruno
	# only a single "," and only a single first name after it with no spaces
	if (/^[^,]+, \w+$/)
	{
		($last, $first) = /^([^,]+), (\w+)$/;
		die "bug" unless defined($first);
		if ($last =~ / /)
		{
			$last = "{$last}";
		}
		return "$first $last";
	}

	#
	# Dispense with possibly single-author forms having a comma,
	# since comma is a possible separator for multi-author forms.
	# All other single-author forms will be handled as multi-author.
	#
	if (!(/\;/ || m/ and / || m/  /))
	{
		my @out = do_author1($_, 0);
		return $out[1] if $out[0];
	}

	#
	# old
	# JA Fessler, and SE Cutler
	#
	if (0 && /^[A-Z]+ $Last/)
	{
		while (/[A-Z]+ $Last/)
		{
			($first, $last, $_) = /([A-Z]+) ($Last)(.*)/;
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
#	undef($author_last);
	if (0 & /,/ & /[^,] and /) # J Fessler, Z Cutler and S Cutler
	{
	#	s/ and /, and /; # trick
		s/ and /; /; # trick
		s/,/;/g; # trick
	}
	if (/;/)
	{
		@_ = split(/; */);
	}
	elsif (/  /) # xxx  yyy  zzz
	{
		@_ = split(/  /);
	}
	elsif (/, and /) # xxx, yyy, and zzz
	{
		s/, and /, /g;
		@_ = split(/, /);
	}
	elsif (/ and /i) # xxx and yyy and zzz (or AND)
	{
		@_ = split(/ and /i);
	}
	elsif (/[A-Z]\.[A-Z]\. [A-Z]/) # J.A. Fessler
	{
		s/ and / /;
		s/\. / /g;
		s/\./ /g;
		@_ = split(/, /);
	}
	elsif (/[A-Z]\.,/) # Fessler, J., Cutler, S.
	{
		s/ and / /;
		@_ = split(/\., /);
	}
	else # xxx, yyy and zzz
	{
		s/ and /, /;
		@_ = split(/, /);
	}
#	print "here it is `@_'\n";

	while ($_ = shift(@_))
	{
		s/ Jr$//; # strip "Jr"
		s/\s*$//; # strip tailing spaces
		s/;//g; # strip semicolons

#		print "`$_'\n";

		my @out = do_author1($_, 1);
		$_ = $out[1];
		s/\./ /g; # cut periods
		s/([A-Z])([A-Z])/$1 $2/g; # AB -> A B
		s/\s+/ /g; # cut double spaces
		$out = $out . "$_  ";
	}

	$out =~ s/\s+$//; # trailing whitespace
	return $out;
}

1; # i guess this is needed
