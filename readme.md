# Prison Pocily Institute 
http://www.prisonpolicy.org/

## Technolgies

### Website
The Front end, still in progress is Rails.
The backend is rails with ActiveAdmin gem to help give a read/write interface, securely, to the content.
Postgres is the database.
Sunspot Solr manages the search

### Scripts to Processs Data
Python and Perl where used to pull in the initial data with other ocr tools.
Shortly more of the data will be in and then the process will check automatically for more content.

## Managing the content

### Update the Home and Contact Page

Log into the website a /admin
Click on Pages.
You can edit there.

## Getting Started
After you pull and run rake db:migrate to get going you will also need to run
on your first install.
rails g sunspot_rails:install
You can seed your database by running
rake db:seed
rake sunspot:reindex
After that you will need to run
rake sunspot:solr:start

Next time you just need to run 
rake sunspot:solr:start

## Road map

## Better editing of content
 * Inline tagging of files
 * Inline creation of Page info
 * Croud source interface 

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

 



