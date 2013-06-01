class CreateFilingDocs < ActiveRecord::Migration
  def change
    create_table :filing_docs do |t|
      t.integer :filing_id
      t.text :url
      t.integer :pagecount
      t.string :doctype
      t.string :filetype
      t.string :sha1hash
      t.string :status

      t.timestamps
    end
  end
end
