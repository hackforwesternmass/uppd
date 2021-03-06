class AddTimestamps < ActiveRecord::Migration
  def up
	execute "alter table locations alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table locations alter column created_at set default LOCALTIMESTAMP"
	execute "alter table filings alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table filings alter column created_at set default LOCALTIMESTAMP"
	execute "alter table taggings alter column created_at set default LOCALTIMESTAMP"
	execute "alter table pages alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table pages alter column created_at set default LOCALTIMESTAMP"
	execute "alter table doc_pages alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table doc_pages alter column created_at set default LOCALTIMESTAMP"
	execute "alter table sections alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table sections alter column created_at set default LOCALTIMESTAMP"
	execute "alter table filing_docs alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table filing_docs alter column created_at set default LOCALTIMESTAMP"
	execute "alter table proceedings alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table proceedings alter column created_at set default LOCALTIMESTAMP"
	execute "alter table active_admin_comments alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table active_admin_comments alter column created_at set default LOCALTIMESTAMP"
	execute "alter table admin_users alter column updated_at set default LOCALTIMESTAMP"
	execute "alter table admin_users alter column created_at set default LOCALTIMESTAMP"
  end

  def down
	execute "alter table locations alter column updated_at drop default"
	execute "alter table locations alter column created_at drop default"
	execute "alter table filings alter column updated_at drop default"
	execute "alter table filings alter column created_at drop default"
	execute "alter table taggings alter column created_at drop default"
	execute "alter table pages alter column updated_at drop default"
	execute "alter table pages alter column created_at drop default"
	execute "alter table doc_pages alter column updated_at drop default"
	execute "alter table doc_pages alter column created_at drop default"
	execute "alter table sections alter column updated_at drop default"
	execute "alter table sections alter column created_at drop default"
	execute "alter table filing_docs alter column updated_at drop default"
	execute "alter table filing_docs alter column created_at drop default"
	execute "alter table proceedings alter column updated_at drop default"
	execute "alter table proceedings alter column created_at drop default"
	execute "alter table active_admin_comments alter column updated_at drop default"
	execute "alter table active_admin_comments alter column created_at drop default"
	execute "alter table admin_users alter column updated_at drop default"
	execute "alter table admin_users alter column created_at drop default"
  end
end
