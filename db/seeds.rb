# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

task_states = TaskState.create([
  {symbol: 'completed', display_name: 'Completed'},
  {symbol: 'pending', display_name: 'Pending'},
  {symbol: 'waiting_for', display_name: 'Waiting for'},
  {symbol: 'work_in_progress', display_name: 'Work in progress'},
])

project_states = ProjectState.create([
  {symbol: 'completed', display_name: 'Completed'},
  {symbol: 'active', display_name: 'Active'},
  {symbol: 'freezed', display_name: 'Freezed'},
])
