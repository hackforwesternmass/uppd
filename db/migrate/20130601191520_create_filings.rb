class CreateFilings < ActiveRecord::Migration
  def change
    create_table :filings do |t|
      t.integer :proceeding_id
      t.string :filing_type
      t.integer :source_id
      t.datetime :recv_date
      t.datetime :posting_date
      t.boolean :exparte
      t.string :author
      t.string :lawfirm

      t.timestamps
    end
  end
end
