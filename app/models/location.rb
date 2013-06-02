class Location < ActiveRecord::Base
  attr_accessible :county, :section_id, :state, :twon, :zip
end
