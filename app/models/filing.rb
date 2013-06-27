class Filing < ActiveRecord::Base
  attr_accessible :applicant, :author, :business_imp, :exparte, :fcc_num, :filing_type, :lawfirm, :posting_date, :proceeding_id, :recv_date
  belongs_to :proceeding
  has_many :filing_docs

  # used to show search criteria and process search queries
  def self.date_metadata
    [
      { label: "After Date", name: :after_date, search_op: "greater_than" },
      { label: "Before Date", name: :before_date, search_op: "less_than" },
    ]
  end
end
