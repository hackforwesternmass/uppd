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
from datetime import datetime

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
}

db_default_value = {
        'applicant': '',
        'lawfirm': '',
        'author': '',
        'filing_type': '',
        'exparte': False,
        'business_imp': False,
        'recv_date': datetime.now(),
        'posting_date': datetime.now(),
        'fcc_num': '',
}

def get_proceeding_id(proceeding_number):
    cursor = db_conn.cursor()
    cursor.execute("SELECT id FROM proceedings WHERE number=%s", (proceeding_number,))
    proceeding_id = None
    proceeding_result = cursor.fetchone()
    if proceeding_result is None:
        stderr.write("Proceeding number " + proceeding_number + " does not exist!!!\n")
    else:
        proceeding_id = proceeding_result[0]

    cursor.close()
    return proceeding_id


def import_filing(filing):
    filing['proceeding_id'] = get_proceeding_id(filing['proceeding.number'])
    filing['created_at'] = datetime.now()
    filing['updated_at'] = datetime.now()

    cursor = db_conn.cursor()

    # For Postgres, default values to 'DEFAULT'
    for column in db_field.values():
        filing.setdefault(column, db_default_value.get(column, None))

    cursor.execute("""INSERT INTO filings
(applicant,
lawfirm,
author,
filing_type,
exparte,
business_imp,
recv_date,
posting_date,
fcc_num,
created_at,
updated_at,
proceeding_id
) VALUES
(%(applicant)s,
%(lawfirm)s,
%(author)s,
%(filing_type)s,
%(exparte)s,
%(business_imp)s,
%(recv_date)s,
%(posting_date)s,
%(fcc_num)s,
%(created_at)s,
%(updated_at)s,
%(proceeding_id)s
) RETURNING lastval()
;""", filing)
    filing_result = cursor.fetchone()
    if filing_result is None:
        stderr.write('filing id not returned\n')
    else:
        filing_id = filing_result[0]

    db_conn.commit()
    cursor.close()

    return filing_id


def import_filing_docs(filing_id, filing_docs):
    for fcc_id, doc in filing_docs.items():
        doc['filing_id'] = filing_id
        doc['created_at'] = datetime.now()
        doc['updated_at'] = datetime.now()

        cursor = db_conn.cursor()
        cursor.execute("""INSERT INTO filing_docs
(filing_id,
fcc_id,
url,
pagecount,
status,
created_at,
updated_at
) VALUES
(%(filing_id)s,
%(fcc_id)s,
%(url)s,
%(pagecount)s,
%(status)s,
%(created_at)s,
%(updated_at)s
);""", doc)

        db_conn.commit()
        cursor.close()

# Column-specific content parsing for entry in the database
def content_parse(column, content):
    # Booleans are 'yes' or 'no' (with case variation)
    if column in ['exparte', 'business_imp']:
        return True if content.lower() == 'yes' else False
    if column in ['recv_date', 'posting_date']:
        try:
            return datetime.strptime(re.sub(r'(\S+)\s.*', r'\1', content), '%Y-%m-%d').date()
        except ValueError as e:
            stderr.write('Incorrect date format: ' + content)
            return content

    return content


db_conn = psycopg2.connect('dbname=uppd_prod user=uppd')

# Compile regular expression search(es), as they're used over and over, for
# performance.
document_link = re.compile(r'.+id=(\d+).*')

comment_ids = []
for comment_id_file in ['comment-id-96-128.txt', 'comment-ids.txt']:
    with open(comment_id_file) as f:
        comment_ids.extend(f.readlines())

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
                # Add a new filing doc for EACH link
                for a in content_span.find_all('a'):
                    doc_id = re.sub(document_link, r'\1',a['href'])
                    filing_docs[doc_id] = {
                            'fcc_id': doc_id,
                            'url': 'http://apps.fcc.gov/ecfs/document/view?id=' + doc_id, 
                            'pagecount': re.sub(r'\D+', '',
                                ''.join(a.stripped_strings)),
                            'status': 'new'
                                }
            # Not a link:
            else:
                db_column = db_field[field.span.label.string.strip()[:-1]]
                filing[db_column] = content_parse(db_column,
                    '\n'.join(content_span.stripped_strings))
            filing['source_id'] = 'http://apps.fcc.gov/ecfs/comment/view?id=' + fccid 
        
    pprint.pprint(filing)
    filing_id = import_filing(filing)
    import_filing_docs(filing_id, filing_docs)
db_conn.close()


