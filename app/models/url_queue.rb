class UrlQueue < ActiveRecord::Base
  attr_accessible :proceeding_id, :status, :url, :url_type
end
