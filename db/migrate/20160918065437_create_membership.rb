class CreateMembership < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true, null: false
      t.references :list, foreign_key: true, null: false
    end
  end
end
