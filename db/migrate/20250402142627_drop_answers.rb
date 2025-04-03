class DropAnswers < ActiveRecord::Migration[7.2]
  def change
    drop_table :answers
  end
end
