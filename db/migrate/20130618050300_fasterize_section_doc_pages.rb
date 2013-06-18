class FasterizeSectionDocPages < ActiveRecord::Migration
  def up
    add_index :doc_pages, :filing_doc_id
    add_index :doc_pages, :pagenumber
    add_index :sections, [:start_page, :end_page], :name => 'pagenumbers'
    add_index :sections, :fcc_num
  end

  def down
    remove_index :doc_pages, :filing_doc_id
    remove_index :doc_pages, :pagenumber
    remove_index :sections, [:start_page, :end_page], :name => 'pagenumbers'
    remove_index :sections, :fcc_num
  end
end
