class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.datetime :deadline, null: false
      t.boolean :done, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
