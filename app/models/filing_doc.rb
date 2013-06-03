class FilingDoc < ActiveRecord::Base
  attr_accessible :doctype, :filetype, :filing_id, :pagecount, :sha1hash, :status, :url
  belongs_to :filing
  has_one :doc_page
end
