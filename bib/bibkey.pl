# bibkey.pl - a perl subroutine
# given an entry in a .b file, generate the "key", e.g. fessler:00:abc
# verify 3 letter codes for .b1 keys

$home = $ENV{HOME};
$ssb = $home . '/l/src/script/bib/';
require $ssb . 'titlecode.pl';

sub bibkey
{
	local(@bib, @line1, $year, $author, $title, $code);
	local($t1, $t2, @t3, $w1, $w2, $w3);

	@bib = split(/\n/, $_[0]);
	die "bibkey problem with `@_'" unless defined($bib[2]);
	(@line1) = split(/\s+/, shift(@bib));
	die "bibkey problem parsing `@_'" unless @line1;
	$year = $line1[$#line1];
	$author = shift(@bib);
	$title = shift(@bib);
	die "title" unless defined($title);

#	$author =~ s/\\Erdogan/Erdogan/;	# trick for Erdogan
#	$author =~ s/\\Esedoglu/Esedoglu/;	# trick for Esedoglu
#	$author =~ s/\\accentu\{(.)\}/$1/g;	# \accentu{ }
	$author =~ s/\\o/o/g;	# \o -> o
	$author =~ s/\\ss/ss/g;	# \ss -> ss (german \beta)
	$author =~ s/\\\"//g;	# remove \"
	$author =~ s/\\//g;	# remove any remaining \
	# {van de graph} to vandegraph
	$author =~ s/\{([^\}]*) ([^\}]*) ([^\}]*)\}/$1$2$3/;
	$author =~ s/\{([^\}]*) ([^\}]*)\}/$1$2/;	# {van dyk} to vandyk
	($author) = split(/  /, $author);	# first author only
	die "no first author in `@bib'" unless defined($author);
	@author = split(/ /, $author);
	$author = $author[$#author];		# last name of 1st auth
	$author =~ s/[\\].//g;			# kill \" etc
	$author =~ s/[\{\}\`\'\-]//g;		# kill punctuation
	$author =~ tr/A-Z/a-z/;			# lower case author

	if ($year =~ /^[0-9]+/)
	{
		die "year $year" if ($year > 2049);
		$year = $year - 2000 if ($year >= 2000);	# 00-49
		$year = $year - 1900 if ($year >= 1950);	# 50-99
		$year = "0$year" if ($year =~ /^[0-9]$/);	# 0 to 00
	}

	$code = &titlecode($title);

	@bibkey = ($author, $year, $code);
}

1;	# apparently needed
