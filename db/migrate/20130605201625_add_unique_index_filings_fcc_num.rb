class AddUniqueIndexFilingsFccNum < ActiveRecord::Migration
  def up
    add_index :filings, :fcc_num, :unique => true, :name => 'unique_fcc_num'
  end

  def down
    remove_index :filings, :fcc_num
  end
end
