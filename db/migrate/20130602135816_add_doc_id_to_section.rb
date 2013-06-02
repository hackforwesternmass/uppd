class AddDocIdToSection < ActiveRecord::Migration
  def up
    add_column :sections, :filing_doc_id, :integer
  end

  def down
    remove_column :sections, :filing_doc_id
  end
end
