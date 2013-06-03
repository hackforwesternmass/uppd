ActiveAdmin.register DocPage do

	index do
	    column :filing_doc_id
	    column :pagenumber
	    column :tag_list
	    column :state_list
	    column :updated_at
	    default_actions
  	end

     form do |f|
   		f.inputs "Details" do
	   		f.input :filing_doc_id
	   		f.input :pagetext
	   		f.input :pagenumber
	   		f.input  :tag_list, :as => :string, :collection => ActsAsTaggableOn::Tag.all.map(&:name),
	   			:label => "Tag", 
	   			:hint => "Separate by comma to use more than one eg 
	   			Example 1, Example 2"
	   		f.input :state_list, :as => :string, :collection => ActsAsTaggableOn::Tag.all.map(&:name),
	   			:label => "State", 
	   			:hint => "Separate by comma to use more than one eg 
	   			Example 1, Example 2"
	   	end

   		f.actions
    end
end

