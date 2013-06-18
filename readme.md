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

 


## Database Notes

# Table: proceedings

    Represents the top level FCC 'case'.
    Proceedings of interest are added to the database (manually) to kick off the text extraction process.
    A proceeding is either 'Open' or 'Closed'. When 'Open', the system will track proceedings and download
    and process associated comments and documents. 'Closed' proceedings are not tracked.
    A proceeding has many filings.

# Table: filings

    A filing represents what the FCC calls a 'comment'. A filing represents a 'statement' by a party with an interest
    in the proceeding. In the case of the prison phone proceedings, interested parties include prisoners, telecom companies,
    attorneys and the FCC. The text extraction system periodically finds new filings and inserts them in the database. A filing
    has various pieces of associated data (author, type, dates, etc.) which are associated with search results.
    
    A filing belongs to a proceeding. 
    A filing has many filing documents.

# Table: filing_docs

    A filing_doc represents the all or part of the content of a filing. Most filings comprise a letter or other single document
    but some may comprise a letter with associated attached evidence or other documents. Note that this is merely descriptive:
    the system does not distinguish among documents in any way. 
    
    A filing_doc belongs to a filing.
    A filing_doc has many sections.
    Note that the fcc_num column is a unique.

    When filing_doc records are initially created, during an FCC site crawl for new filings or documents, only a subset of
    columns have data. Column values that associated with the content of the document are updated after the document is
    subsequently fetched and processed.

# Table: doc_pages

   This table contains the extracted text (where possible) of each page of a document. Its existence allows the content
   of the FCC documents to be searchable (modulo successful extraction).

# Table: sections

  A section represents some page subset of a document, whether a single page, a range of pages, or the whole document.
  This table provides a level of abstraction that allows a human editor to annotate or tag a document without directly
  modifying the document or pages tables directly, since that would complicate the automated updated of those tables.

  A section belongs to filing_docs. Note that this relationship is based on the fcc_num value and not the primary key.
  This is necessary to allow offline creation of annotations. In such cases, the FCC document number is more available
  that the filing_doc.id value (which may not even exist when the annotation is created).
