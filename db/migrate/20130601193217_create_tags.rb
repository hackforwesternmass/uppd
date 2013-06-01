class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :doc_page_id
      t.string :tag

      t.timestamps
    end
  end
end
