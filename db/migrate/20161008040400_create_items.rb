class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :list, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.boolean :completed, default: false, null: false
      t.boolean :starred, default: false, null: false
      t.integer :priority, default: 0, null: false
      t.date :due_date
      t.text :notes

      t.timestamps
    end
  end
end
