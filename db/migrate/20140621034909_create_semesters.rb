class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.integer :year
      t.integer :half
      t.timestamps
    end
  end
end
