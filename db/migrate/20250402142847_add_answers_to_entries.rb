class AddAnswersToEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :entries, :answers, :json
  end
end
