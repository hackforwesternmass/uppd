#!/bin/env python

"""
proceeding.py is responsible for maintaining a queue of comment and document
urls for every proceeding we are interested in.

Since the remote system that does not keep track of what items we've seen,
there's a unique index in the urls_queues table to prevent multiple submissions
for the same url.

As a result, the update task is inelegantly simple minded and brutish:

Search the FCC site for all proceedings we care about,
Grab all relevant urls and push them into the table.
If the record already exists, the insert throws particular error, which we ignore.

After the initial import, most runs will only add a few new records at a time,
if any.

It can be run once a day, perhap under cron, with the command

  python .../uppd/feed/proceeding.py run

The script uses the RAILS_ENV environment variable to determine run modes
so this should be set, either implicitly (rails runner "exec ...") or explicitly env RAILS_ENV=production.

It defaults to development when unset.

Other scripts process the records in url_queues and are discussed elsewhere.

Author: Gyepi Sam <self-github@gyepi.com>

"""

import re
from lxml import html
from utils import *
import db

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

        for href in content.xpath('//table[@class="dataTable"]//td/a/@href'):
            if re.search('/ecfs/comment/view.+id=', href):
                yield ('comment', hostify_url(clean_url(href)))

def queue_urls():
    """imports all proceeding comment and document links into queue table"""
    conn = db.connection()
    cur = conn.cursor()
    cur.execute("SELECT id, number FROM proceedings where status = 'Open'")

    try:
        proceedings = cur.fetchall()
    except Exception, e:
        warn("cannot fetch proceeding numbers", e)
        raise

    conn.commit()

    conn.autocommit = True # needed for ignoring duplicates

    for proc_id, number in proceedings:
        for url_type, url in parse_proceeding(number):
            try:
                cur.execute("INSERT INTO url_queues (proceeding_id, url_type, url) values (%s, %s, %s)", [proc_id, url_type, url])
            except Exception as e:
                if not re.match('ERROR:\s+duplicate.+"unique_url"', e.pgerror):
                    raise

    conn.close()

if __name__ == "__main__":
    import pprint
    import sys

    action = sys.argv[1]
    if action == 'test':
        pp = pprint.PrettyPrinter(indent=4)
        pp.pprint([x for x in parse_proceeding(sys.argv[2])])
    elif action == 'run':
        queue_urls()
