class AddPomodorroSessionsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :pomodorro_sessions, :integer
  end
end
