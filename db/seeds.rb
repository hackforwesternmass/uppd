# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Page.create!(title: 'Home Page', body: 'More Coming Soon...')
Page.create!(title: 'Contact Page', body: 'More Coming Soon...')

Proceeding.delete_all
Filing.delete_all
FilingDoc.delete_all
DocPage.delete_all
30.times do |n|
	Proceeding.create!(number: "Proceeding #{n}")
	Filing.create!(
			proceeding_id: n,
			filing_type: "Test",
			source_id: n,
			recv_date: Time.now,
			author: "Test #{n}",
			lawfirm: "Test #{n}",
			exparte: 1,
	)
	FilingDoc.create!(
		filing_id: n,
		url: 'http://google.com',
		pagecount: 2,
		doctype: 'test',
		filetype:  'pdf',
	)
	DocPage.create!(
		filing_doc_id: n,
		pagenumber: 2,
		pagetext:  Faker::Lorem.paragraph(4),
		wordcount: 200,
	)
end