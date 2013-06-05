#/bin/env python
""" Database functions """


import os
import os.path as path
import sys
import re
import psycopg2

# database connection. Will be set when necessary.
CONNECTION = None

def connection_args():
    """Reads config/database.yml returns the database configuration
    matching RAILS_ENV value"""

    env = os.getenv('RAILS_ENV', 'development') + ':'

    # assume that the main file lives inside the rails dir
    config = path.join(path.dirname(path.abspath(sys.argv[0])), 
                       "../config/database.yml")

    # maps yaml key names to postgres connection names
    fields = {
        'database': 'dbname',
        'username': 'user',
        'password': 'password',
        'host': 'host',
        }

    data = []
    found = False 

    with open(config) as f:
        for line in f:
            line = line.strip()
            if line == env:
                found = True
            elif found and not line:
                break
            else:
                match = re.search('(\w+):\s*(.+)$', line)
                if match:
                    try:
                        key = fields[match.group(1)]
                        data.append('%s=%s' % (key,  match.group(2)))
                    except KeyError:
                        pass 


    return ' '.join(data)

def connection():
    """Stores and returns a handle to the database"""
    global CONNECTION
    #TODO -- check for lost connection and retry...
    if not CONNECTION:
        CONNECTION = psycopg2.connect(connection_args())

    return CONNECTION

def cursor():
    """..."""
    return connection().cursor()

def dict_to_sql_insert(tablename, data):
    """constructs and returns a pair of string and data to be
    handed off to sql.execute"""

    values = data.values()
    query = "INSERT INTO %s (%s) VALUES (%s) RETURNING lastval()" % \
        (tablename, ', '.join(data.keys()), ', '.join(['%s'] * len(values)))

    return [query, values]

if __name__ == "__main__":
    print connection_args()
