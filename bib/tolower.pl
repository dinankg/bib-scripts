# tolower.pl
# perl subroutines for title case conversion

# leave these words capitalized
@caps = ('American', 'Arnoldi',
'Barzilai', 'Borwein', 'Bregman',
'BaF', 'Bayesian', 'Bloch', 'Boltzmann',
'Carlo', 'CdZnTe', 'Chebyshev', 'Chinese', 'Cholesky', 'Compton', 'CsI',
'Fermat', 'Fisher', 'Fourier',
'Ga-67', 'Gabor', 'Gaussian', 'Gibbs', 'Grassman',
'Haar',
'Hadamard', 'Hamming', 'Hankel', 'Hilbert', 'Hopfield', 'Hough',
'Japanese', 'Johann', 'John\'s',
'Kaiser', 'Kalman', 'Krylov',
'Lagrange', 'Lagrangian', 'Laguerre', 'Larrabee', 'Laurent', 'Legendre',
'Markov', 'Mersenne', 'MeV', 'Monte', 'MRI',
'NaI', 'Navier', 'Newton', 'Nvidia',
'Poisson',
'Radon', 'Siegert', 'SPECT',
'Tc-99', 'Tesla', 'Tl-201', 'Toeplitz', 'ToF',
'Walsh', 'Wold',
'X-ray');

# Exact, it-W

#
# convert a word to lower case
#
sub tolower {
	local($tmp) = $_[0];
	$tmp =~ tr/A-Z/a-z/;
	return $tmp;
}

#
# convert most of title to lower case
#
sub TitleLower {
	#	protect special words with ZZZ at front
	local($title) = $_[0];
	for (@caps) {
		$title =~ s/($_)/ZZZ$1/g if ($title =~ /$_/);
	}

	(local($title1), $title) = $title =~ /\s*(\w+)(.*)/;
	$title =~ s/([- ][A-Z][a-z])/&tolower($1)/ge;

	$title = $title1 . $title;
	$title =~ s/ZZZ//g;	# clear out caps-protecting ZZZ
	return $title;
}

1; # apparently needed
