class ChangeSectionsFccNumToString < ActiveRecord::Migration
  def up
    change_column :sections, :fcc_num, :string
  end

  def down
    change_column :sections, :fcc_num, :integer
  end
end
