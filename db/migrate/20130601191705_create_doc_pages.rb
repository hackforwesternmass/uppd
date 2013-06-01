class CreateDocPages < ActiveRecord::Migration
  def change
    create_table :doc_pages do |t|
      t.integer :filing_doc_id
      t.integer :pagenumber
      t.text :pagetext
      t.integer :wordcount

      t.timestamps
    end
  end
end
