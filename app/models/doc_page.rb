class DocPage < ActiveRecord::Base
  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount, :tag_list, :state_list
  belongs_to :filing_doc
  acts_as_taggable
  acts_as_taggable_on :tag, :state

	searchable do 
		text :pagetext, :tag_list, :state_list
	end

end
