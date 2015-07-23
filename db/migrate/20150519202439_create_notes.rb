class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :description
      t.text :body

      t.timestamps null: false
    end
  end
end
