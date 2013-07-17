class DocumentTag < ActiveRecord::Base
  attr_accessible :section_id, :tag_id, :tag_count
  belongs_to :section
  belongs_to :tag

  def dom_id(prefix=nil)
    [prefix, "context", context.downcase.gsub(/\s/,'_')].compact.join('_')
  end

  def extended_attributes
    attributes.merge('dom_id_root' => dom_id)
  end
end
