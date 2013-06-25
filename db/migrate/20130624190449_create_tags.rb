class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :context
      t.integer :position
      t.string :name
      t.string :scope
      t.timestamps
    end
    add_index :tags, [:context, :name, :position], :name => :tag_label
  end
end
