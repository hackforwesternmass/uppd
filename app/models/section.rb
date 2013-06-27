class Section < ActiveRecord::Base
  
  attr_accessible :end_page, :start_page, :fcc_num, :filing_doc_id

  belongs_to :filing_doc, :foreign_key => 'fcc_num', :primary_key => 'fcc_num'
 
  # TODO: This has been obsoleted by tags - remove after migration 
  has_many :section_filers

  has_many :doc_pages, :finder_sql => Proc.new {
    [<<-EOS, filing_doc_id, start_page, end_page]
    SELECT * FROM doc_pages WHERE filing_doc_id = ? AND pagenumber BETWEEN ? AND ?
    EOS
  }

  has_many :document_tags

end
