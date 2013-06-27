class SetDocumentTagsTimestampDefaults < ActiveRecord::Migration
  def up
    execute "alter table document_tags alter column updated_at set default LOCALTIMESTAMP"
    execute "alter table document_tags alter column created_at set default LOCALTIMESTAMP"
  end

  def down
    execute "alter table document_tags alter column updated_at drop default"
    execute "alter table document_tags alter column created_at drop default"
  end
end
