require 'csv'    

filename = ARGV.shift

#"Proceeding","Document No.","Start page","End page","State","IdentitIncarcerated person"
#"12-375",7022419922,1,2,"NC",

ActiveRecord::Base.transaction do
  lineno = 0
  CSV.foreach(filename, :headers => false) do |row|
      lineno += 1
      next if lineno == 1

      _, fcc_num, start_page, end_page, statecode, incarcerated_text = row

      section_attributes = {:fcc_num => fcc_num, :start_page => start_page, :end_page => end_page}

      section = Section.first(:conditions => section_attributes) || Section.create!(section_attributes)

      filer_attributes = {:statecode => statecode, :incarcerated => incarcerated_text.to_s.downcase.strip == "incarcerated person"}

      unless section.filers.exists?(filer_attributes)
        SectionFiler.create!(filer_attributes.merge(:section_id => section.id))
      end
  end
end
