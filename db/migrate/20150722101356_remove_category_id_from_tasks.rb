class RemoveCategoryIdFromTasks < ActiveRecord::Migration
  def change
    remove_index :tasks, column: :category_id
    remove_column :tasks, :category_id
  end
end
