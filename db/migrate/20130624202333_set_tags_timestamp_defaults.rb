class SetTagsTimestampDefaults < ActiveRecord::Migration
  def up
    execute "alter table tags alter column updated_at set default LOCALTIMESTAMP"
    execute "alter table tags alter column created_at set default LOCALTIMESTAMP"

  end

  def down
    execute "alter table tags alter column updated_at drop default"
    execute "alter table tags alter column created_at drop default"
  end
end
