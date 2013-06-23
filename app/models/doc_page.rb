class DocPage < ActiveRecord::Base
  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount
  #, :tag_list, :state_list
  
  belongs_to :filing_doc
  has_one :filing, :through => :filing_doc
  
  #acts_as_taggable
  #acts_as_taggable_on :tag, :state

  searchable do 
    text :pagetext
    #string :state_list
    #string :tag_list, :multiple => true, :stored => true
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
