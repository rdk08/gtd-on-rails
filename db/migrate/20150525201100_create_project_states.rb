class CreateProjectStates < ActiveRecord::Migration
  def change
    create_table :project_states do |t|
      t.string :state

      t.timestamps null: false
    end
  end
end
