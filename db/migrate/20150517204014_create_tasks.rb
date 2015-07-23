class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.references :task_state, index: true, foreign_key: true
      t.boolean :have_to
      t.date :date
      t.string :date_hour
      t.boolean :date_due
      t.datetime :completed_at
      t.references :project, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.string :additional_info

      t.timestamps null: false
    end
  end
end
