class AddFccIdAndFccNumAndBusinessImpAndApplicantToFiling < ActiveRecord::Migration
  def up
    add_column :filings, :fcc_id, :integer
    add_column :filings, :fcc_num, :string
    add_column :filings, :business_imp, :boolean
    add_column :filings, :applicant, :string
  end

  def down
    remove_column :filings, :fcc_id
    remove_column :filings, :fcc_num
    remove_column :filings, :business_imp
    remove_column :filings, :applicant
  end
end
