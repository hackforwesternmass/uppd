class ChangeFilingDocIdToFccNumOnSections < ActiveRecord::Migration
  def up
    rename_column :sections, :filing_doc_id, :fcc_num
  end

  def down
    rename_column :sections, :fcc_num, :filing_doc_id
  end
end
