class InsertTagsData < ActiveRecord::Migration
  def up
    require'yaml'

    text = <<-EOS
Location:
  - State of Origin
  - section

Identity:
  - Prison/jail phone company
  - document
  - Telecommunications company not in prison/jail market
  - document
  - Correctional institution/official
  - document
  - Incarcerated person
  - section
  - Individual, not incarcerated
  - section
  - State regulators
  - document
  - Non-governmental organization
  - document
  - FCC document
  - document
  - Not relevant
  - document
  EOS

    data = YAML.load(text)

    ActiveRecord::Base.transaction do
      data.each do |context, rows|
        pos = 0
        rows.each_slice(2) do |name, scope|
          pos += 1
          Tag.create!(:context => context, :name => name, :scope => scope, :position => pos)
        end
      end
    end
  end

  def down
    execute "delete from tags"
  end
end
