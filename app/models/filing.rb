class Filing < ActiveRecord::Base
  attr_accessible :author, :exparte, :filing_type, :lawfirm, :posting_date, :proceeding_id, :recv_date, :source_id
  belongs_to :proceeding
  has_many	:filing_docs


end
