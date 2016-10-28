class AddItemUserForeignKey < ActiveRecord::Migration[5.0]
  def up
    execute "ALTER TABLE items ADD FOREIGN KEY (user_id, list_id) REFERENCES memberships(user_id, list_id) ON UPDATE RESTRICT ON DELETE RESTRICT;"
  end

  def down
    #execute "ALTER TABLE  DROP FOREIGN KEY ;"
  end
end
