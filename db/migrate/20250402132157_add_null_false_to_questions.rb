class AddNullFalseToQuestions < ActiveRecord::Migration[7.2]
  def change
    change_column_null :questions, :content, false
  end
end
