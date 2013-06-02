class Proceeding < ActiveRecord::Base
  attr_accessible :number
  has_many :filings
end
