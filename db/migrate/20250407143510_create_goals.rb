class CreateGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :goals do |t|
      t.string :title
      t.text :description
      t.integer :progress

      t.timestamps
    end
  end
end
