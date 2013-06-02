class DropTableTags < ActiveRecord::Migration
  def up
  	drop_table :tags
  end
end
