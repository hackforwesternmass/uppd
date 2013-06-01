#!/usr/bin/python2

#########################################################
# parse_proceedings.py                                  #
# Parse FCC ECFS RSS feeds                              #
# Author: Jonathan Hills <jonathan.e.hills@gmail.com>   #
#########################################################

import feedparser
import sys
import pprint

feed_list = []
with open('rss_feeds.txt', 'r') as f:
    # Note: assignment [feed_list = f.readlines()] will create a new feeds,
    # locally scoped. Using the method [list].extend fixes this.
    feed_list.extend(f.readlines())

feeds = map(feedparser.parse, feed_list)

for proc in feeds:
    # HTTP status OK?
    if proc['status'] != 200:
        sys.stderr.write('Failed to fetch proceeding at ' +
                proc['href'] + ': ' + proc['status'] + '\n')

    for filing in proc['entries']:
        pprint.pprint(filing, depth=1, indent=4)
