class Section < ActiveRecord::Base
  attr_accessible :end_page, :start_page, :fcc_num
  belongs_to :filing_doc, :foreign_key => 'fcc_num', :primary_key => 'fcc_num'
end
