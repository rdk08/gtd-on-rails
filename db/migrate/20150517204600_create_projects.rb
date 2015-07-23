class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :description
      t.string :goal_description
      t.date :soft_deadline
      t.date :hard_deadline
      t.references :project_state, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
