class RemoveFilingDocAndDocPageFromTags < ActiveRecord::Migration
  def up
    add_column :tags, :section_id, :integer
    remove_column :tags, :doc_page_id
  end

  def down
    add_column :tags, :doc_page_id, :integer
    remove_column :tags, :section_id
  end
end
