class AddFilingDocIdToSection < ActiveRecord::Migration
  def up 
    add_column :sections, :filing_doc_id, :integer
    add_index :sections, :filing_doc_id

    ActiveRecord::Base.transaction do
        execute <<-EOS
        update sections set filing_doc_id = filing_docs.id from filing_docs where sections.fcc_num = filing_docs.fcc_num
        EOS
    end
  end

  def down
    remove_column :sections, :filing_doc_id, :integer
    remove_index :sections, :filing_doc_id
  end
end
