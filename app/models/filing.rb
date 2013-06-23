class Filing < ActiveRecord::Base
  attr_accessible :applicant, :author, :business_imp, :exparte, :fcc_num, :filing_type, :lawfirm, :posting_date, :proceeding_id, :recv_date
  belongs_to :proceeding
  has_many :filing_docs
end
