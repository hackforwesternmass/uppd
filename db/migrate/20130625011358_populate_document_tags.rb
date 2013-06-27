class PopulateDocumentTags < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
        incarcerated_id = Tag.where({:context => 'Identity', :name => 'Incarcerated person'}).first.id
        SectionFiler.all.each do |section_filer|
            unless (statecode = section_filer.statecode).blank?
                tag = Tag.first(:conditions => {:context => "State Code", :name => section_filer.statecode})
                DocumentTag.create!(:section_id => section_filer.section_id, :tag_id => tag.id, :tag_count => 1) 
            end

            if section_filer.incarcerated
                DocumentTag.create!(:section_id => section_filer.section_id, :tag_id => incarcerated_id, :tag_count => 1)
            end
        end
    end
  end

  def down
    execute "delete from document_tags"
  end
end
