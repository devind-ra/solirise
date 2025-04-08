class UpdateGoalsTable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :goals, :title, false
    change_column_default :goals, :progress, from: nil, to: 0
  end
end
