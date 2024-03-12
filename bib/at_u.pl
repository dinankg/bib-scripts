#!/bin/perl -w
# u.pl
# convert my shorthand into complete url
# u spie volume
# u ieee isNumber arNumber
# u doi doi
# u osa key
# u jnm vol num page
# u snm issue page
# u ovid accession_number
# u nejm vol num page
# u statsin vol num article
# ...

sub u2url
{
	$_ = $_[0];
	local($url, $vol, $num, $arnum, $isnum, @in);
	@in = split(" ");
	@in = ("dummy", @in);

#	print "u2url: @in\n"; exit(-1);

	if ($in[1] eq "ct" and defined($in[2]))
	{
		if ($in[2] eq "old18")
		{
		#	$url = "http://www.ucair.med.utah.edu/CTmeeting/CT2018_Proceedings.pdf";
			$in[3] += 18 if defined($in[3]);
			$url = $url . "#page=" . $in[3] if (defined($in[3]));
		}

		elsif ($in[2] eq "old16")
		{
		#	$url = "http://ctmeeting.shpci.org/data/ProceedingsCTMeeting2016.pdf";
			$url = "https://ct-meeting.org/wp-content/uploads/2021/11/ProceedingsCTMeeting2016.pdf";
		}

		else # seems to be unified in 2022!
		{
		#	$root = "http://www.ucair.med.utah.edu/CTmeeting/ProceedingsCTMeeting20";
		#	$root = "http://www.ct-meeting.org/data/ProceedingsCTMeeting20" . $in[2] . ".pdf";
			$root = "https://ct-meeting.org/wp-content/uploads/2021/11/ProceedingsCTMeeting20";
			$url = $root . $in[2] . ".pdf";
			# 14: add 16
		#	$in[3] += 16 if ($in[2] eq "14" && defined($in[3]));
			$url = $url . "#page=" . $in[3] if (defined($in[3]));
		}
	}

	elsif ($in[1] eq "spie")
	{
		die "bad spie `$_'" unless defined($in[2]);
		$vol = $in[2];
		$url = 'http://spiedl.aip.org/dbt/dbt.jsp?KEY=PSISDG&';
		$url = $url . "Volume=" . $vol ."\&Issue=1";

	}

	elsif ($in[1] eq "ieee")
	{
		die "bad ieee `$_'" unless defined($in[3]);
		$isnum = $in[2];
		$arnum = $in[3];
#old		$url = 'http://ieeexplore.ieee.org/xpls/abs_all.jsp?';
#old		$url = $url . "isNumber=" . $isnum . "\&arNumber=" . $arnum;
#journal	$url = 'http://ieeexplore.ieee.org/search/wrapper.jsp?';
#journal	$url = $url . "arnumber=" . $arnum;
		$arnum =~ s/^0*//; # strip leading zeros from article #
		$url = 'http://ieeexplore.ieee.org/search/srchabstract.jsp?';
		$url = $url . "arnumber=" . $arnum;
		$url = $url . "&k2dockey=" . $arnum . "\@ieeecnfs";

#new:
#@u ieee 21916 1018792
#http://ieeexplore.ieee.org/search/wrapper.jsp?arnumber=1018792

	}

	elsif ($in[1] eq "ads")
	{
		die "bad ads `$_'" unless defined($in[2]);
		$code = $in[2];
		$url = 'http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=' . $code;

	}

	elsif ($in[1] eq "ajr")
	{
		die "bad ajr `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$pag = $in[4];
		$url = "http://www.ajronline.org/cgi/content/abstract";
		$url = "$url/$vol/$num/$pag";

	}

	elsif ($in[1] eq "arxiv")
	{
		die "bad arxiv `$_'" unless defined($in[2]);
		$num = $in[2];
		$url = "http://arxiv.org/abs/$num";
	}

	elsif ($in[1] eq "biorxiv")
	{
		die "bad biorxiv `$_'" unless defined($in[2]);
		$num = $in[2];
		$url = 'http://doi.org/' . $num;
	}

	elsif ($in[1] eq "doi")
	{
	#	print "doi: $in[2]\n"; exit(-1);
		die "bad doi `$_'" unless defined($in[2]);
		$num = $in[2];
		$url = 'http://doi.org/' . $num;

	}

	elsif ($in[1] eq "hdl")
	{
		die "bad hdl `$_'" unless defined($in[2]);
		$handle = $in[2];
		$url = 'https://hdl.handle.net/' . $handle;
	}

	elsif ($in[1] eq "ismrm")
	{
		# 2006 and 2009- here:
		$ismrm2 = "http://dev.ismrm.org/"; # default
		$ismrm0 = "http://cds.ismrm.org"; # typical root
		$ismrm1 = "$ismrm0/protected"; # typical root
		$ismrm3 = "http://archive.ismrm.org"; # / year / num4.html
		$ismrmd = "https://doi.org/10.58530"; # / year / num4  DOI!

		die "bad ismrm `$_'" unless defined($in[3]);
		$year = $in[2];
		$page = $in[3];

		$page4 = $page;
		if ($page =~ /^\d/) {
			$page4 = sprintf("%04d", $page);
		}

		$url = "$ismrm3/year/$page.html"; # default for 2006 and 2009-

		$ismrm4 = "https://index.mirasmart.com/ISMRM$year/PDFfiles/$page.html";
		$ismrm5 = "https://index.mirasmart.com/ISMRM$year/PDFfiles/$page4.html";

		if ($year == 2023) {
			$ismrm23 = "https://submissions.mirasmart.com/ISMRM2023/Itinerary/Files/PDFFiles/"; # 4050.html
			$url = "$ismrm23$page4.html";
		}

		elsif ($year == 2013) {
		#	$url = "$ismrm1/13MProceedings/files/$page4.PDF";
		}

		elsif ($year == -2008 || $year == -2007 || $year == -2006) {
			$url = "$ismrm0/ismrm-$year/files/$page.pdf";
		}

		elsif ($year == 2005 || $year == 2004) {
			$url = "$ismrm0/ismrm-$year/Files/$page.pdf";
		}

		elsif ($year == 2002 || $year == 2000 || $year == 1999) {
			$url = "$ismrm0/ismrm-$year/$page.PDF";
		}

		elsif ($year == 2001) {
			$url = "$ismrm0/ismrm-$year/$page.pdf";
		}

		else { # try this by default:
		#	$url = "$ismrm0/ismrm-$year/$page.pdf";
			die "bad $_" unless defined($page4);
		#	$url = "$ismrm3/$year/$page4.html";
			$url = "$ismrmd/$year/$page"; # doi!
		}

	}

	elsif ($in[1] eq "jnm")
	{
		die "bad jnm `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$pag = $in[4];
		$url = "http://$in[1].snmjournals.org/cgi/content/abstract";
		$url = "$url/$vol/$num/$pag";

	}

	elsif ($in[1] eq "jstor")
	{
		die "bad jstor `$_'" unless defined($in[2]);
		$code = $in[2];
		$url = 'http://www.jstor.org/stable/' . $code;
	}

	elsif ($in[1] eq "nejm")
	{
		die "bad nejm `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$pag = $in[4];
		$url = "http://content.nejm.org/cgi/content/abstract";
		$url = "$url/$vol/$num/$pag";

	}

	elsif ($in[1] eq "osa")
	{
		die "bad osa `$_'" unless defined($in[2]);
		$num = $in[2];
		$jour = $num;
		$jour =~ s/-.*//;
		$url = 'http://www.opticsinfobase.org/';
		$url = $url . $jour . '/abstract.cfm?URI=' . $num;
#		$url = 'http://www.opticsinfobase.org/$jour/abstract.cfm?URI=' . $num;
	}

	elsif ($in[1] eq "ovid")
	{
		die "bad ovid `$_'" unless defined($in[2]);
		$ovid = $in[2];
		$url = "http://gateway.ovid.com/ovidweb.cgi?T=JS&MODE=ovid&NEWS=n&PAGE=toc&D=ovft&AN=" . $ovid;

	}

	elsif ($in[1] eq "pmid")
	{
		die "bad pmid `$_'" unless defined($in[2]);
		$pmid = $in[2];
		$url = sprintf("http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=%s&query_hl=1", $pmid);

	}

	elsif ($in[1] eq "pmlr")
	{
		die "bad pmlr `$_'" unless defined($in[3]);
		$vol = $in[2];
		$num = $in[3];
		$url = sprintf("http://proceedings.mlr.press/v%s/%s.html", $vol, $num);
	}

	elsif ($in[1] eq "pnas")
	{
		die "bad pnas `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$pag = $in[4];
		$url = "http://www.pnas.org/content";
		$url = "$url/$vol/$num/$pag";

	}

	elsif ($in[1] eq "radiology" || $in[1] eq "radiographics")
	{
		die "bad radiology `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$pag = $in[4];
		$url = "http://$in[1].rsnajnls.org/cgi/content/abstract";
		$url = "$url/$vol/$num/$pag";
	}

	elsif ($in[1] eq "siam-news") {
		die "bad siam `$_'" unless defined($in[2]);
		$url = "https://sinews.siam.org/Details-Page/$in[2]"
	}

	elsif ($in[1] eq "siam-news-arch") {
		die "bad siam-news-arch `$_'" unless defined($in[2]);
		$url = "https://archive.siam.org/news/news.php?id=$in[2]"
	}

	elsif ($in[1] eq "snm") # snm is a mess - inconsistent between years...
	{
		die "bad snm `$_'" unless defined($in[3]);
		$vol = $in[2];
		$pag = $in[3];
		$pabs = "meeting_abstract";
		$pabs ="abstract" if ($vol eq 47);
		$mabs ="1_MeetingAbstracts";
		$mabs ="suppl_1";
		if ($vol eq 47) {
			$url = "http://jnm.snmjournals.org/content/$vol/suppl_1/$pag";
		} elsif ($vol eq 48) {
			$url = "http://jnm.snmjournals.org/content/$vol/supplement_2/$pag";
		} else {
			$mabs ="MeetingAbstracts_1" if ($vol eq 49);
			$mabs ="2_MeetingAbstracts" if ($vol eq 51);
		#	$url = "http://jnumedmtg.snmjournals.org/cgi/content/$pabs/$vol/$mabs/$pag";
			$url = "http://jnm.snmjournals.org/content/$vol/supplement_1/$pag";
		}
	}

	elsif ($in[1] eq "statsin")
	{
		die "bad statsin `$_'" unless defined($in[4]);
		$vol = $in[2];
		$num = $in[3];
		$art = $in[4];
		$tmp = "j$vol" . "n$num";
		$url = "http://www3.stat.sinica.edu.tw/statistica";
		$url = "$url/$tmp/$tmp$art/$tmp$art.htm";
	}

	elsif ($in[1] =~ /jour\//)
	{
		$root = "http://web.eecs.umich.edu/~fessler/papers/files";
		$url = "$root/$in[1]";
	}

	elsif ($in[1] =~ /proc\//)
	{
		$root = "http://web.eecs.umich.edu/~fessler/papers/files";
		$url = "$root/$in[1]";
	}

	elsif ($in[1] =~ /tr\//)
	{
		$root = "http://web.eecs.umich.edu/~fessler/papers/files";
		$url = "$root/$in[1]";

	}

	else
	{
		shift(@in);
		$url = "@in";
	}

	return $url;
}

1; # i guess this is needed
