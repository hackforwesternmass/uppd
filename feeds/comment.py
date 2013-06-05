#!/bin/env python

"""
comment.py updates filing and filing_docs tables during import.

"""

from lxml import html
import re
from utils import *
import db

# maps FCC comment labels to local field names.
# a value is either a string, or a sequence consisting of a string and a lambda.
# The string is used as the column name and the lambda, if any, is used to transform or cleanup
# the associated data value.

FILING_MAP = {
      'Attorney/Author Name:': 'author',
      'Date Posted:': ['posting_date', lambda(x) : re.sub('\..+$', '', x)],
      'Date Received:': ['recv_date', lambda(x) : re.sub('\..+$', '', x)],
      'Exparte:': ['exparte', lambda(x) : x.lower() == 'yes'],
      'Lawfirm Name:': 'lawfirm',
      'Name of Filer:': 'applicant',
      'Small Business Impact:': ['business_imp', lambda(x) : x.lower() == 'yes'],
      'Type of Filing:': 'filing_type',
      }

def parse_comment(url):
    """Parses content of comment url and returns two values; a dict for filing and a list of dicts for associated filing_docs"""
    
    comment = {}
    documents = []

    data = [comment, documents]

    try:
        page = html.parse(url)

        # Grab all items in data section
        items = page.xpath('//div[@class="wwgrp"]/span')
    except Exception as e:
        warn(e, 'url: ' + url)
        return data

    # iterate pairs of label, content
    for label, content in zip(items[::2], items[1::2]):
        # verify that we are in the right spot
        try:
            label_text = label.xpath('string(.//label[@class="label"]/text())').strip()
        except Exception as e:
            warn("cannot parse label: %s: %s" % (label, e))
            continue

        node = content.xpath('.//a')

        if node: # A list of urls...
            if label_text == 'Proceeding Number:': # Ignore link back to proceeding
                pass 
            elif label_text == 'View Filing:':     # But grab document links
                for anchor in node:
                    url = hostify_url(clean_url(anchor.get('href')))
                    doc = { 'url': url }

                    m = re.search('id=(\d+)$', url)
                    if m:
                        doc['fcc_num'] = m.group(1)

                    m = re.search('View\s+\((\d+)\)', anchor.text)
                    if m:
                        doc['pagecount'] = m.group(1)
                    
                    documents.append(doc)
            else:
                warn("Unexpected label: %s for url nodes: %s" % (label_text, node))
        else:   # plain text...
            field = FILING_MAP.get(label_text)
            if field:
                try:
                    key, mutator = field
                except ValueError:
                    key, mutator = field, lambda(x) : x

                comment[key] = mutator(content.text.strip())

    return data


def import_comment(url):
    """
    The contents of url is imported into the filings table and the filing_docs table.
    If the record is not new,  the insert fails with a duplicate error, which causes the attempt to be abandonded.
    Otherwise the associated documents, if any, are also added.
    """

    conn = db.connection()
    cur = conn.cursor()

    try:
        filing, documents = parse_comment(url)
    except Exception as e:
        warn("Error %s on url: %s" % (e, url))
        return
    
    try:
        cur.execute(*db.dict_to_sql_insert("filings", filing))
    except Exception as e:
        if re.match('ERROR:\s+duplicate', e.pgerror):
            return
        else:
            conn.rollback()
            warn("Error %s while importing comment: %s" % (e, url))
    else:
        filing_id = cur.fetchone()

        for doc in documents:
            doc['filing_id'] = filing_id
            try:
                cur.execute(*db.dict_to_sql_insert("filing_docs", doc))
            except Exception as e:
                conn.rollback()
                warn("Error %s while importing documents %s for comment: %s" % (e, doc, url))
                return

        conn.commit()

if  __name__ == "__main__":
    import pprint
    import sys
    pp = pprint.PrettyPrinter(indent=4)
    pp.pprint(parse_comment(sys.argv[2]))
