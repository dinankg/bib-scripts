# titlecode.pl - a perl subroutine
# given the title line for an entry in a .b file,
# generate the 3-letter "code", e.g., 'abc' for the paper 'A big circuit'

sub titlecode {
	local($title, $code);
	local($t1, $t2, @t3, $w1, $w2, $w3);

	$title = $_[0];
	$title =~ s/, / /g;		# replace ', ' with just ' ' in title
	$title =~ s/\. / /g;		# replace '. ' with just ' ' in title
	$title =~ s/(\d)\//$1/g;	# replace "1/k" with "1k"
	$title =~ s/ \& / /g;		# replace ' & ' with a single space
	$title =~ s/(\d)\.(\d)/$1$2/g;	# 1.0 -> 10
	$title =~ s/[\(\)\'\`\$\"\{\}\^\_\*\+\\\:\!\|]*//g; # kill punctuation
	$title =~ s/---/ /g;		# replace --- with a space
	$title =~ s/--/ /g;		# replace -- with a space
	$title =~ s/ - / /g;		# replace ' - ' with a space
	$title =~ s/- / /g;		# replace '- ' with a space
	$title =~ s/-/ /g;		# replace '-' with a space

#	print "t $title\n";

	($w1, $w2, $w3) = split(/[ -\/]/, $title);

	$t1 = "";	$t1 = $w1 if defined($w1); $t1 =~ s/(.).*/$1/;
	$t2 = "";	$t2 = $w2 if defined($w2); $t2 =~ s/(.).*/$1/;
	$t3 = "";	$t3 = $w3 if defined($w3); $t3 =~ s/(.).*/$1/;
	$code = "$t1$t2$t3";
	$code =~ tr/A-Z/a-z/;

	return $code;
}

1; # apparently needed
