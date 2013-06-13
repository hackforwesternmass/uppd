class Section < ActiveRecord::Base
  attr_accessible :end_page, :start_page, :filing_doc_id
  belongs_to :doc_page
end
