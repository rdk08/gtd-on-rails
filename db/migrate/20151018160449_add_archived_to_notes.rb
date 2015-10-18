class AddArchivedToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :archived, :boolean
  end
end
