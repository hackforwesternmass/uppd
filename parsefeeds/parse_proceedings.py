#!/usr/bin/python2

#########################################################
# parse_proceedings.py                                  #
# Parse FCC ECFS Proceedings                            #
# Author: Jonathan Hills <jonathan.e.hills@gmail.com>   #
#########################################################

from sys import exit, stderr
import re
import urllib2
import psycopg2
from bs4 import BeautifulSoup
from datetime import strptime

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

db_conn = psycopg2.connect('dbname=uppd_prod user=uppd')

# Column-specific content parsing for entry in the database
def content_parse(column, content):
    # Booleans are 'yes' or 'no' (with case variation)
    if column in ['exparte', 'business_imp']:
        return True if content.lower() == 'yes' else False
    # TODO: date parsing
    if column in ['recv_date', 'posting_date']:
        try:
            return strptime(content, "")
        except ValueError as e:
            stderr.write('Incorrect date format: ' + content)
            return content

    return content
#        return content.lower() == 
    """
        'recv_date',
        'posting_date',
        """


# Compile regular expression search(es), as they're used over and over, for
# performance.
document_link = re.compile(r'.+id=(\d+).*')

comment_ids = []
with open('comment-ids.txt') as f:
    comment_ids = f.readlines()

comment_ids = map(lambda s: s.strip(), comment_ids)

for fccid in comment_ids:
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
                doc_id = re.sub(document_link, r'\1',content_span.a['href'])
                filing_docs[doc_id] = {
                        'fcc_id': doc_id,
                        'url': 'http://apps.fcc.gov/ecfs/document/view?id=' + doc_id, 
                        'pagecount': re.sub(r'\D+', '',
                                ''.join(content_span.a.stripped_strings)),
                        'status': 'new'
                            }
            # Not a link:
            else:
                db_column = db_field[field.span.label.string.strip()[:-1]]
                filing[db_column] = content_parse(db_column,
                    '\n'.join(content_span.stripped_strings))

        # TODO: insert/update filing, doc, proceeding in DB
    print filing['recv_date']

db_conn.close()
