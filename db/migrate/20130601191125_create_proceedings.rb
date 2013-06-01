class CreateProceedings < ActiveRecord::Migration
  def change
    create_table :proceedings do |t|
      t.string :number

      t.timestamps
    end
  end
end
