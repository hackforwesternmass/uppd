class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :section_id
      t.string :state
      t.string :county
      t.string :twon
      t.string :zip

      t.timestamps
    end
  end
end
