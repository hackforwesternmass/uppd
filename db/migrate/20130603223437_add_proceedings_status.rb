class AddProceedingsStatus < ActiveRecord::Migration
  def up
	add_column :proceedings, :status, :string, {:default => 'Open'}
	add_index  :proceedings, :status
  end

  def down
	remove_index  :proceedings, :status
	remove_column :proceedings, :status
  end
end
