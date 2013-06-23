class CreateSectionFilers < ActiveRecord::Migration
  def change
    create_table :section_filers do |t|
      t.integer :section_id
      t.string :statecode, :limit => 2
      t.boolean :incarcerated, :default => false
      t.timestamps
    end
    add_index :section_filers, :section_id
    add_index :section_filers, :statecode
    add_index :section_filers, :incarcerated
  end
end
