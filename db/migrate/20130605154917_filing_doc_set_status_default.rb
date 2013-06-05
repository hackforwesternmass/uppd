class FilingDocSetStatusDefault < ActiveRecord::Migration
  def up
    change_column :filing_docs, :status, :string, :default => 'new'
    add_index :filing_docs, :status
  end

  def down
    remove_index :filing_docs, :status
    change_column :filing_docs, :status, :string
  end
end
