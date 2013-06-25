class Tag < ActiveRecord::Base
  attr_accessible :context, :name, :scope, :position
end
