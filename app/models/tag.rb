class Tag < ActiveRecord::Base
  attr_accessible :context, :name, :scope, :position

  def self.grouped_tags
        find_by_sql(<<-EOS).group_by(&:context)
        select context, name, id from tags order by context, position
        EOS
  end

  def self.contexts_to_var
    find_by_sql(<<-EOS).map(&:context_to_var)
    select distinct context from tags order by context
    EOS
  end

  def self.context_to_var(context)
    context.to_s.downcase.gsub(' ', '_')
  end

  def context_to_var
    self.class.context_to_var(context)
  end

  # simplify for view...
  def self.context_metadata
    grouped_tags.map do |label, options|
      [label, context_to_var(label), options]
    end
  end
end
