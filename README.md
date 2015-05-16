# Prison Policy Initiative 
http://www.prisonpolicy.org/!

## Technolgies

### Website
The Front end, still in progress is Rails.
We are using the Foundation framework for the theme.

The backend is rails with ActiveAdmin gem to help give a read/write interface, securely, to the content.
Postgres is the database.
Sunspot Solr manages the search

### Scripts to Processs Data
Python and Perl where used to pull in the initial data with other ocr tools.
Shortly more of the data will be in and then the process will check automatically for more content.

# Managing the content

## Update the Home and Contact Page

Log into the website a /admin
Click on Pages.
You can edit there.

## Deploy code

Once your are ready to deploy put your code into master and type cap deploy at the command of your local project.
Keep in mind db:migrate is not working yet. Soon it will. For now you have to login and do it in the /var/www/uppd/current folder.

# Road map

## Better search interface
We are finlalizing some import work. As far as the display goes we are not sure what to show on the search pages but these are some of the thought.
User clicks search.
User ends up on results
Results show 
 1. A link to the page that will show a preview of the PDF
 2. A link to the document at the FCC site to download.
 3. Tags
 4. State Tags.
 5. Link back to Filing

 
 # Scraping

http://apps.fcc.gov/ecfs/proceeding/ is a good example of a page the leads to Documents.

 # DB Schema


# Requirements

apt-get install libpq-dev

# Archive
The original site has been archived.
The database dump db/archive-2015-05-16.sql.gz and the file
can be used to bootstrap a new site.
