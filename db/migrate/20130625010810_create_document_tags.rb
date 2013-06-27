class CreateDocumentTags < ActiveRecord::Migration
  def change
    create_table :document_tags do |t|
      t.integer :section_id
      t.integer :tag_id
      t.integer :tag_count, :default => 0, :null => false
      t.timestamps
    end
    add_index :document_tags, [:section_id, :tag_id], :name => :tagged_item
  end
end
