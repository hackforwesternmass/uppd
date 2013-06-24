class DocPage < ActiveRecord::Base
  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount
  
  belongs_to :filing_doc
  has_one :filing, :through => :filing_doc
  
  searchable do 
    text :pagetext
    #TODO add tag items here.
  end

  def section
    Section.find_by_sql([" 
                          SELECT s.*
                          FROM sections s
                          JOIN filing_docs f ON s.fcc_num = f.fcc_num
                          AND f.id = ?
                          AND ? BETWEEN s.start_page AND s.end_page
                         ", filing_doc_id, pagenumber]).first
  end

  def section_filer
    section.section_filer rescue nil 
  end
end
