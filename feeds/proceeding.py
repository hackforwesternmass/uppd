#!/bin/env python

"""
proceeding.py is responsible for adding new filings
for every proceeding we are interested in.

Since the remote system that does not keep track of what items we've seen,
there's a unique index on the filing.fcc_num  column
to prevent multiple submissions for the same data.

As a result, the update task is inelegantly simple minded and brutish:

Search the FCC site for all proceedings we care about.
Grab all relevant filings and add them to the table.
Existing records will fail and new records will succeed.

After the initial import, most runs will only add a few new records at a time,
if any.

It can be run once a day, perhap under cron, with the command

  python .../uppd/feed/proceeding.py run

The script uses the RAILS_ENV environment variable to determine run modes
so this should be set, either implicitly (rails runner "exec ...") or explicitly env RAILS_ENV=production.

It defaults to development when unset.

Author: Gyepi Sam <self-github@gyepi.com>

"""

import re
from lxml import html
from utils import *
import db
import comment

def parse_proceeding(proceeding_num):
    """A generator that runs a search on FCC site and produces
    urls for comments and documents relating to specified proceeding number"""

    # In addition to search results, the first page also contains
    # links to subsequent pages
    # which will be subsequently followed.

    try:
        url = search_url(proceeding_num)
    
        content = html.parse(url)
    
        todo = [content] # addenda...

        pages = [] # pages to follow and process
        cache = {} # ensure unique set

        for url in content.xpath('//span[@class="pagelinks"]//a[contains(@href, "/ecfs/comment_search/paginate")]/@href'):
            if not url in cache:
                pages.append(hostify_url(url))
                cache[url] = True

    except Exception as e:
        warn('url: ', url)
        raise e

    # Where there are more than 10 or so pages, the site lists the first N then the last page.
    # For a set of page numbers like 1 2 3 4 5 6 7  N
    # where N is the final page number, we interpolate from 7 + 1 to N - 1
    # If there are no missing values, 7 + 1 would be greater than N - 1 and the range would be empty.
    if len(pages) > 1:
        lastpage = pages.pop()

        lastpage_match = re.match('(.+pageNumber=)(\d+)', lastpage)
        penultimate_match = re.match('(.+pageNumber=)(\d+)', pages[-1])
        for number in range(int(penultimate_match.group(2)) + 1, int(lastpage_match.group(2)) - 1):
            pages.append(lastpage_match.group(1) + str(number))

        pages.append(lastpage)

    todo.extend(pages)
      
    for item in todo:
        if hasattr(item, 'xpath'):
            content = item 
        else:
            try:
                content = html.parse(item)
            except Exception as e:
                warn("Error fetching or parsing link", item, e)
                continue

        for href in content.xpath('//table[@class="dataTable"]//td/a[contains(@href, "/ecfs/comment/view")]/@href'):
            yield hostify_url(clean_url(href))

def import_comments():
    """imports all proceeding comments into filing table and documents into filing_docs table"""

    conn = db.connection()
    cur = conn.cursor()
    cur.execute("SELECT id, number FROM proceedings where status = 'Open'")

    try:
        proceedings = cur.fetchall()
    except Exception, e:
        warn("cannot fetch proceeding numbers", e)
        raise

    conn.commit()

    for proc_id, number in proceedings:
        for url in parse_proceeding(number):
            comment.import_comment(url)

    conn.close()

if __name__ == "__main__":
    import pprint
    import sys

    action = sys.argv[1]
    if action == 'test':
        pp = pprint.PrettyPrinter(indent=4)
        pp.pprint([x for x in parse_proceeding(sys.argv[2])])
    elif action == 'run':
        import_comments()
