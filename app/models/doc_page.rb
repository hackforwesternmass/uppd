class DocPage < ActiveRecord::Base
  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount
end
