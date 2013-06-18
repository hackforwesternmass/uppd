class Section < ActiveRecord::Base
  attr_accessible :end_page, :start_page, :fcc_num
  belongs_to :filing_doc, :foreign_key => 'fcc_num', :primary_key => 'fcc_num'
  has_many :doc_pages, :finder_sql => Proc.new {
     "
        SELECT d.*
        FROM doc_pages d
        JOIN filing_docs f ON d.filing_doc_id = f.id
        AND f.fcc_num = '#{fcc_num}'
        AND d.pagenumber BETWEEN #{start_page} AND #{end_page}
     "
  }
end
