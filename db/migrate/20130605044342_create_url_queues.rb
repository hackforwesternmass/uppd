class CreateUrlQueues < ActiveRecord::Migration
  def change
    create_table :url_queues do |t|
      t.integer :proceeding_id
      t.string :url_type
      t.string :url
      t.string :status, :default => 'new'
      t.timestamps
    end
    add_index(:url_queues, :status)
    add_index(:url_queues, [:proceeding_id, :url_type, :url], :unique => true, :name => 'unique_url')
  end
end
