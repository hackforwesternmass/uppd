class FilingDocRenameFccIdToToFccNum < ActiveRecord::Migration
  change_table :filing_docs do |t|
    t.rename :fcc_id, :fcc_num
  end
end
