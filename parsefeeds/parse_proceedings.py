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
import psycopg2
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

    # All the fields seemed to be wrapped in divs of class wwgrp
    fields = filter(lambda tag: 'class' in tag.attrs and 'wwgrp' in tag['class'],
            soup.find_all('div'))

    filing = {}
    filing_docs = {}
    for field in fields:
        # Each div consists of two spans. The first contains a label with the
        # name of the field in it. The second contains various content:
        # usually just text, but sometimes links (in the case of documents or
        # a div (in the case of an address)
        if ('class' in field.span.attrs and 'wwlbl' in field.span['class'] and
                field.span.label.string.strip()[:-1] in db_field):
            # Second span: content
            content_span = field.find_all('span')[1]
            if ('View Filing' in field.span.label.string.strip() and
                    content_span.a):
                # Add a new filing doc
                filing_docs[re.sub(document_link, r'\1',
                    content_span.a['href'])] = {
                            'url': content_span.a['href'],
                            'pagecount': re.sub(r'\D+', '',
                                ''.join(content_span.a.stripped_strings)),
                            'status': 'new'
                            }
                    # TODO: prepare a filing_doc db entry
            # Not a link:
            else:
                filing[db_field[field.span.label.string.strip()[:-1]]] = '\n'.join(
                        content_span.stripped_strings)

        # TODO: insert/update filing, doc, proceeding in DB


