class InsertTagsData < ActiveRecord::Migration
  def up
    require'yaml'

    text = <<-EOS
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

    statecodes = %w(AK AL AR AS AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS
                    MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UT VA VI VT WA WI WV WY)

    data = YAML.load(text)
    data["State Code"] = statecodes.map { |code| [code, "section"] }.flatten

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
