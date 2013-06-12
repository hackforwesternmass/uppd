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
	filingLast = Filing.create!(
			proceeding_id: n,
			filing_type: "Test",
			recv_date: Time.now,
			author: "Test #{n}",
			lawfirm: "Test #{n}",
			exparte: 1,
	)
	3.times do |d|
		docLast = FilingDoc.create!(
			filing_id: filingLast.id,
			url: 'http://google.com',
			pagecount: 2,
			doctype: 'test',
			filetype:  'pdf',
		)
		DocPage.create!(
			filing_doc_id: docLast.id,
			pagenumber: 2,
			pagetext:  Faker::Lorem.paragraph(4),
			wordcount: 200,
			tag_list: "Test #{n}",
		)
	end
end
