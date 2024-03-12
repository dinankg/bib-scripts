# author1last.pl - a perl subroutine
# given the author entry of a .b file, generate the last name of first author

sub author1last
{
	$_ = $_[0];
	s/  .*//; # cut all but first author
	s/\{([^\}]*) ([^\}]*) ([^\}]*)\}/$1$2$3/; # {van de graph} to vandegraph
	s/\{([^\}]*) ([^\}]*)\}/$1$2/;	 # {van dyk} to vandyk
	s/.* //;
#	my @author = split(/ /);
#	$_ = $author[$#author];		# last name of 1st auth
	s/\\//g;			# cut \
#	s/[\\].//g;			# cut \" etc
	s/[\{\}\`\'\-\\]//g;		# cut punctuation
	tr/A-Z/a-z/;			# lower case author
	return $_;
}

1; # apparently needed
