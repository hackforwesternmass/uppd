class AddFccIdToFilingDoc < ActiveRecord::Migration
  def up
    add_column :filing_docs, :fcc_id, :string
  end

  def down
    remove_column :filing_docs, :fcc_id
  end
end
