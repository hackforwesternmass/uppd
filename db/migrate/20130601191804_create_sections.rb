class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :start_page
      t.integer :end_page

      t.timestamps
    end
  end
end
