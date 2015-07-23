class CreateTaskStates < ActiveRecord::Migration
  def change
    create_table :task_states do |t|
      t.string :symbol, primary_key: true
      t.string :display_name

      t.timestamps null: false
    end
  end
end
