#!/usr/bin/python2

#########################################################
# parse_proceedings.py                                  #
# Parse FCC ECFS Proceedings                            #
# Author: Jonathan Hills <jonathan.e.hills@gmail.com>   #
#########################################################

from sys import exit, stderr
import json
import re
import urllib2
from bs4 import BeautifulSoup

import pprint

# html name => db column
db_field = {
        'Proceeding Number': 'proceeding.number',
        'Name of Filer': 'applicant',
        'Lawfirm Name': 'lawfirm',
        'Attorney/Author Name': 'author',
        'View Filing': None,
        'Type of Filing': 'filing_type',
        'Exparte': 'exparte',
        'Small Business Impact': 'business_imp',
        'Date Received': 'recv_date',
        'Date Posted': 'posting_date',
        'DA/FCC Number': 'fcc_num',
        'Address': 'address',
}

# Compile regular expression searches, as they're used over and over, for
# performance.
document_link = re.compile(r'<a href="[^"]+document[^"]+id=(\d+)"\D*?(\d+)[^<]*')

for fccid in ["5507721128", "5507719820", "5507719590"]:
    soup = BeautifulSoup(
            urllib2.urlopen(
                'http://apps.fcc.gov/ecfs/comment/view?id='+ fccid).read())

    fields = filter(lambda tag: 'class' in tag.attrs and 'wwgrp' in tag['class'],
            soup.find_all('div'))

    """html = re.sub(newline_characters, '', html)
    html = re.sub(proceeding_number, r'\1', html)
    html = re.sub(document_link, r'\1: \2 ', html)
    html = re.sub(html_tag, r'', html)
    html = re.sub(repeated_space, r' ', html)
    html = re.sub(word_colon, r'\1', html)


    html = re.sub(proceeding_number, r'\1',
            re.sub(html_tag, r'',
            re.sub(repeated_space, r'\1',
            re.sub(document_link, r'\1: \2\n',
            html))))"""

    filing = {}
    for field in fields:
        if ('class' in field.span.attrs and 'wwlbl' in field.span['class'] and
                field.span.label.string.strip()[:-1] in db_field):
            print field.find_all('span')[1]
            if ('View Filing' in field.span.label.string.strip() and
                    field.find_all('span')[1].a):
                # Add a new filing doc
                filing_docs[re.sub(document_link, r'\1',
                    field.find_all('span')[1].a['href'])] = {

#            filing[field.span.string.strip()[:-1]] = field.span.next_sibling.string.strip()
    print filing
    print '--------------------------------------'

