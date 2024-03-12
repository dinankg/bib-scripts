# toupper.pl
# convert to upper case (often used for just the first letter of a title)

sub toupper {
	local($tmp) = $_[0];
	$tmp =~ tr/a-z/A-Z/;
	return $tmp;
}

1; # apparently needed
