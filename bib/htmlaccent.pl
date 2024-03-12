#!/bin/perl -w
# htmlaccent.pl
# subroutine for reformatting html strings for special letters into tex
# open http://www.fileformat.info/info/unicode/char/search.htm
# open http://www.w3.org/TR/REC-html40/sgml/entities.html
# open http://www.htmlcodetutorial.com/characterentities.html

sub htmlaccent {
	local($saver, $out);
	$saver = $_;
	$_ = $_[0];

#	s/R&C/R \\& C/g; # trick for pmb 61,1

	# remove italics, bold, fonts
	s/\<\/?i\>//ig;
	s/\<\/?b\>//ig;
	s/\<\/?font[^\>\<]*\>//gi;

	# pictures where case matters
	s/\<(img|IMG) [^\>\<]*Delta[^\>\<]*\>/\$\\Delta\$/g;
	s/\<(img|IMG) [^\>\<]*Gamma[^\>\<]*\>/\$\\Gamma\$/g;

	# greek letters, possibly with pictures
	s/(\<img [^\>\<]*alpha[^\>\<]*\>)|(\&alpha\;)/\$\\alpha\$/gi;
	s/(\<img [^\>\<]*beta[^\>\<]*\>)|(\&beta\;)/\$\\beta\$/gi;
	s/(\<img [^\>\<]*gamma[^\>\<]*\>)|(\&gamma\;)/\$\\gamma\$/gi;
	s/(\<img [^\>\<]*lambda[^\>\<]*\>)|(\&lambda\;)/\$\\lambda\$/gi;
	s/(\<img [^\>\<]*mu[^\>\<]*\>)|(\&mu\;)/\$\\mu\$/gi;
	s/(\<img [^\>\<]*pi[^\>\<]*\>)|(\&pi\;)/\$\\pi\$/gi;
	s/\<img [^\>\<]*rho[^\>\<]*\>/\$\\rho\$/gi;
	s/\<img [^\>\<]*theta[^\>\<]*\>/\$\\theta\$/gi;
	s/\<img [^\>\<]*vecE[^\>\<]*\>/\$\\E\$/gi;
	s/\<img [^\>\<]*leq[^\>\<]*\>/\$\\leq\$/gi;
	s/\<img [^\>\<]*prime[^\>\<]*\>/\$'\$/gi;
	s/\<img [^\>\<]*L-bar[^\>\<]*\>/\$\\bar\{L\}\$/gi;
	s/\<img [^\>\<]*alt="([^\"]*)"[^\>\<]*\>/$1/gi;	# anything else

	s/&lt;/\$\\lt\$/g;	# cannot use '<' or it will mess up html parsing
	s/&reg;/(R)/g;
	s/(&#169;|&copy;)/\\copyright{}/g; # (circle c)
	s/(&#174;|&reg;)/\\registeredtrademark{}/g; # registered trademark (circle R)
	s/(&#175;|&macr;)/\$^-\$/g; # spacing overline
	s/(&#176;|&deg;)/\$^{\\circ}\$/g;
	s/(&#177;|&plusmn;)/\$^{\\pm}\$/g;
	s/(&middot;|&sdot;)/\$\\cdot\$/g;
	s/&dot;/\$^.\$/g;
	s/&amp;/\&/g;

	s/(&#211;|&Oacute;)/\\'O/g;
	s/(&#215;|&times;)/\$\\times\$/g;

	s/&pound;/\$\\pounds\$/g;	# british pound
	s/&bull;/ \* /g; # bullet

	s/&emsp;/ /g;			# ? space
	s/(&#160;|&nbsp;)/ /g;		# non-breaking space
	s/(&#8201;|&thinsp;)//g;	# thin space
	s/&#8210;/-/g;
	s/(&#8211;|&endash;|&ndash;)/-/g;
	s/(&#8212;|&emdash;|&mdash;)/-/g;
	s/(&#8216;|&lsquo;)/\`/g;	# left single quote
	s/(&#8217;|&rsquo;)/\'/g;	# right single quote
	s/&prime;/\'/g;			# right single quote
	s/&#697;/\'/g;			# right single quote
	s/(&#8220;|&ldquo;)/\`\`/g;	# left double quote
	s/(&#8221;|&rdquo;)/\'\'/g;	# right double quote
	s/&quot;/\"/g;

	s/&#8467;/\$\\ell\$/g;
	s/(&#8482;|&trade;)/ (TM)/g;	# trademark sign (^TM)

	s/(&#181;|&micro;)/\$\\mu\$/g;

	if (/\@url/) {	# trick: for doi url's for MRM, allow <,>
		s/(&#60;|&lt;)/\</g;
		s/(&#62;|&gt;)/\>/g;
	} else {
		s/(&#60;|&lt;)/\$\<\$/g;
		s/(&#62;|&gt;)/\$\>\$/g;
	}

	s/&#150;/-/g;
	s/&#151;|&mdash;/--/g; # longer dash
	s/&#8211;/-/g;
	s/&#8212;/--/g;	# a longer dash

#	s/&#191;|&iquest;/\\?/g; % inverted question mark
	s/&#192;|&Agrave;/\\`A/g;
	s/&#193;|&Aacute;/\\'A/g;
	s/&#194;|&Acirc;/\\^{A}/g;
	s/&#195;|&Atilde;/\\~{A}/g;
	s/&#196;|&Auml;/\\"A/g;
	s/&#197;|&Aring;/{\\AA}/g;
	s/&#198;|&AElig;/{\\AE}/g;
	s/&#199;|&Ccedil;/{\\c{C}}/g;
	s/&#200;|&Egrave;/\\`E/g;
	s/&#201;|&Eacute;/{\\'{E}}/g;
	s/&#202;|&Ecirc;/{\\^{E}}/g;

	s/&#214;|&Ouml;/\\"O/g;
	s/&#216;|&Oslash;/{\\O}/g;

	s/&#220;|&Uuml;/\\"U/g;

	s/&#223;|&szlig;/{\\ss}/g;
	s/&#224;|&agrave;/\\`a/g;
	s/&#225;|&aacute;/\\'a/g;
	s/&#226;|&acirc;/\\^a/g;
	s/&#227;|&atilde;/\\~a/g;
	s/&#228;|&auml;/\\"a/g;
	s/&#229;|&aring;/{\\aa}/g;
	s/&#230;|&aelig;/{\\ae}/g;
	s/&#231;|&ccedil;/\\c{c}/g;
	s/&#232;|&egrave;/\\`e/g;
	s/&#233;|&eacute;/\\'e/g;
	s/&#234;|&ecirc;/\\^e/g;
	s/&#235;|&euml;/\\"e/g;
	s/&#236;|&igrave;/\\`i/g;
	s/&#237;|&iacute;/\\'i/g;
	s/&#238;|&icirc;/\\^i/g;
	s/&#239;|&iuml;/\\"i/g;
	s/&#240;|&eth;/{e}/g;		# ? upside-down e
	s/&#241;|&ntilde;/\\~n/g;
	s/&#242;|&ograve;/\\`o/g;
	s/&#243;|&oacute;/\\'o/g;
	s/&#244;|&ocirc;/\\^o/g;
	s/&#245;|&otilde;/\\~o/g;
	s/&#246;|&ouml;/\\"o/g;
	s/&#247;|&divide;/\$\\div\$/g;
	s/&#248;|&oslash;/\\{o}/g;
	s/&scaron;/\\v{s}/g;
	s/&#249;|&ugrave;/\\`u/g;
	s/&#250;|&uacute;/\\'u/g;
	s/&#251;|&ucirc;/\\^u/g;
	s/&#252;|&uuml;/\\"u/g;
	s/&#253;|&yacute;/\\'y/g;

	s/&lowast;/\*/g; # convolution asterisk

	s/&#263;/\\v{c}/g;
	s/&#267;/\\\.{c}/g;
	s/&#268;/\\v{C}/g;

	s/&#321;/\\L/g;
	s/&#352;/\\v{S}/g;
	s/&#353;/\\v{s}/g;
	s/&#382;/\\v{z}/g;

	s/&#700;/\'/g;
	s/&#730;/\$\\circ\$/g; # maybe it is some other circle?

	s/(&#915;|&Gamma;)/\$\\Gamma\$/g;
	s/(&#916;|&Delta;)/\$\\Delta\$/g;
	s/(&#923;|&Lambda;)/\$\\Lambda\$/g;
	s/(&#931;|&Sigma;)/\$\\Sigma\$/g;
	s/(&#937;|&Omega;)/\$\\Omega\$/g;
	s/(&#945;|&alpha;)/\$\\alpha\$/g;
	s/(&#946;|&beta;)/\$\\beta\$/g;
	s/(&#947;|&gamma;)/\$\\gamma\$/g;
	s/(&#948;|&delta;)/\$\\delta\$/g;
	s/(&#949;|&epsilon;|&epsiv;)/\$\\varepsilon\$/g;
	s/&upsih;/\$\\Upsilon\$/g;
	s/(&#952;|&theta;)/\$\\theta\$/g;
	s/&#955;/\$\\lambda\$/g;
	s/&#956;/\$\\mu\$/g;
	s/(&#957;|&nu;)/\$\\nu\$/g;
	s/(&#960;|&pi;)/\$\\pi\$/g;
	s/(&#961;|&rho;)/\$\\rho\$/g;
	s/(&#963;|&sigma;)/\$\\sigma\$/g;
	s/(&#964;|&tau;)/\$\\tau\$/g;
	s/(&#966;|&#981|&phi;)/\$\\phi\$/g;
	s/&Phi;/\$\\Phi\$/g;
	s/&chi;/\$\\chi\$/g;
	s/(&#969;|&omega;)/\$\\omega\$/g;

	s/&#1009;/\$\\varrho\$/g;
	s/&#1013;/\$\\varepsilon\$/g;

	s/(&#8544;)/I/g;
	s/(&#8545;)/II/g;
	s/(&#8546;)/III/g;
	s/(&#8547;)/IV/g;

	s/(&#8706;|&part;)/\$\\partial\$/g;
	s/(&#8711;|&nabla;)/\$\\nabla\$/g;
	s/(&#8722;|&minus;)/\-/g; # minus sign
	s/(&#8734;|&infin;)/\$\\infty\$/g;
	s/(&#8747;|&int;)/\$\\int\$/g;
	s/&#8771;/\$\\approx\$/g; # some version of approx equal
	s/(&#8776;|&asymp;)/\$\\approx\$/g; # asymp equal
	s/&sim;/\$\\approx\$/g; # ~
	s/&empty;/\$\\emptyset\$/g; # empty set
	s/(&#8804;|&le;)/\$\\leq\$/g;
	s/(&#8805;|&ge;)/\$\\geq\$/g;
	s/(&#8810;|&ll;)/\$\\ll\$/g;
	s/(&#8811;|&gg;)/\$\\gg\$/g;
	s/(&#8834;|&sub;)/\$\\subset\$/g; # subset

	s/&#9653;/\$\\Delta\$/g;
	s/&#10877;/\$\\leq\$/g;
	s/&#10878;/\$\\geq\$/g;
	s/&#12296;/\$\\langle\$/g; # left angle bracket
	s/&#12297;/\$\\rangle\$/g; # right angle bracket

	s/(&#61620;|&times;)/\$\\times\$/g; # ?
	s/&#65279;/?/g; # ?

	s/<sup><sup>([^\<\>]*)<\/sup><\/sup>/\$^{$1}\$/gi; # double superscript!
	s/<sup>([^\<\>]*)<\/sup>/\$^{$1}\$/gi;	# superscript
	s/<sub>([^\<\>]*)<\/sub>/\$_{$1}\$/gi;	# subscript

# ieee specific (?):
	s/&Hscr;/\$H\$/g;	# mathcal{H} approximation
	s/&Kscr;/\$K\$/g;	# mathcal{K} approximation
	s/&Lscr;/\$L\$/g;	# mathcal{L} approximation

	s/&darr;/\$\\downarrow\$/g;
	s/&rarr;/\$\\rightarrow\$/g;
	s/&isin;/\$\\in\$/g;

	s/&lowbar;//g;	# underline - exclude because pointless in title
	s/&aleph;/aleph/g;	# hebrew "N"?

	s/&#x0?0C4;/\\"a/g; # a with two dots over it
	s/&#x0?0C9;/\\'e/g;
	s/&#x0?0CA;/\\^e/g; # hat over e
	s/&#x0?0CF;/\\:i/g; # naive
	s/&#x0?0D3;/\\'o/g;
	s/&#x0?0d7;/\$\\times\$/ig;
	s/&#x0?0DC;/\\:u/g;
	s/&#x0?103;/\\v{a}/g;
	s/&#x0?107;/\\\'c/g;
	s/&#x0?10D;/\\v{c}/g;
	s/&#x0?11B;/\\v{e}/g;
	s/&#x0?130;/I/g; # 'I' with dot.  just make it I
	s/&#x0?131;/i/g; # 'i' without dot.  just make it i.
	s/&#x0?15F;/\\scedil/g;
	s/&#x0?160;/\\v{S}/g;
	s/(&#x0?163;|&tcedil;)/\\c{t}/g;
	s/&#x0?17B;/\\.{Z}/g;
	s/&#x0?17E;/\\v{z}/g;
	s/&#x0?142;/l/g; # should be l with dash through it. just make it l.
	s/&#x0?144;/\\\'{n}/g;
	s/&#x0?2013;/-/g;
	s/&#x0?2014;/--/g;
	s/&#x0?201C;/"/g; # left
	s/&#x0?201D;/"/g; # right
	s/&#x0?2122;/(TM)/g; # trademark superscript
	s/&#x0?2212;/-/g;
	s/&#x0?221e;/\\infty/g;
	s/&#x0?2264;/\\leq/g;
	s/&#x0?2265;/\\geq/g;
	s/&#x0?226A;/\\ll/g; # much less than

	$out = $_;
	$_ = $saver;
	return $out;
}

1;	# i guess this is needed
