class SectionFiler < ActiveRecord::Base
  attr_accessible :statecode, :incarcerated, :section_id
  belongs_to :section
end
