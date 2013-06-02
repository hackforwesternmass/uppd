class DocPage < ActiveRecord::Base
  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount, :tag_list, :state_list
  acts_as_taggable
  acts_as_taggable_on :tag, :state

	searchable do 
		text :pagetext, :tag_list, :state_list
		# will come back to this once I can deploy the solr setup
		# text :tag_list do	
		# 	tag_list.map(&:name)
		# end
	end

end
