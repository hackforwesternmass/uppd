class Proceeding < ActiveRecord::Base
  attr_accessible :number, :status
  has_many :filings
end
