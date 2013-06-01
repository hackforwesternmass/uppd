class FilingDoc < ActiveRecord::Base
  attr_accessible :doctype, :filetype, :filing_id, :pagecount, :sha1hash, :status, :url
end
