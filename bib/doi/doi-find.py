#!/usr/bin/env python
# from http://tex.stackexchange.com/questions/6810/automatically-adding-doi-fields-to-a-hand-made-bibliography
# see: https://pypi.python.org/pypi/zs.bibtex

import httplib, urllib, re, sys, cgi
from zs.bibtex.parser import parse_string

# Search for the DOI given a title; e.g.  "computation in Noisy Radio Networks"
def searchdoi(title, author):
	params = urllib.urlencode({"titlesearch":"titlesearch", "auth2" : author, "atitle2" : title, "multi_hit" : "on", "article_title_search" : "Search", "queryType" : "author-title"})
	headers = {"User-Agent": "Mozilla/5.0" , "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded", "Host" : "www.crossref.org"}
	conn = httplib.HTTPConnection("www.crossref.org:80")
	conn.request("POST", "/guestquery/", params, headers)
	response = conn.getresponse()
	# print response.status, response.reason
	data = response.read()
	conn.close()
	return data


# Main body

f = open(sys.argv[1], 'r')
inputdata = f.read()

# remove any leftover commas otherwise Bibtex parser crashed
inputdata = re.sub(r",(\s*})",r"\1", inputdata)

try:
	bibliography = parse_string(inputdata)
except:
	err = sys.exc_info()[1]
	print "Unexpected parsing error:", err
	sys.exit()

for paper in bibliography:
	try:
		title = bibliography[paper]['title']
		author = bibliography[paper]['author']
		if (isinstance(author,list)):
			author = author[0]
		author = str(author)
		author = re.sub(r"[{}'\\]","", author)
		# remove any of the characters that might confuse CrossRef
		title = re.sub(r"[{}]","", title)
		title = re.sub(r"\$.*?\$","",title) # better remove all math expressions
		title = re.sub(r"[^a-zA-Z0-9 ]", " ", title)
		print "<h1>DOIs for:<br>Title: %s<br>Author: %s<br> </h1>" % (title, author)
		out = searchdoi(title,author)
		result = re.findall(r"\<table cellspacing=1 cellpadding=1 width=600 border=0\>.*?\<\/table\>" ,out, re.DOTALL)
		if (len(result) > 0):
			print(result[0])
		else:
			print("Bad response from server<br><br>")
	except:
		print "Error with: ", bibliography[paper]
