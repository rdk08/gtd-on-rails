class ChangeDescriptionToTitleInNote < ActiveRecord::Migration
  def change
    rename_column :notes, :description, :title
  end
end
