class ChangeColumnsInProjectState < ActiveRecord::Migration
  def change
    rename_column :project_states, :state, :symbol
    add_column :project_states, :display_name,  :string
  end
end
