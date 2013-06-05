class RemoveExtraneousIdFields < ActiveRecord::Migration
  def up
    # These are duplicates of fcc_num and should be char anyway...
    remove_column :filings, :source_id
    remove_column :filings, :fcc_id
  end

  def down
    add_column :filings, :source_id, :integer
    add_column :filings, :fcc_id, :integer
  end
end
