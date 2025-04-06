class AddTitleToAppraisals < ActiveRecord::Migration[7.2]
  def change
    add_column :appraisals, :title, :string
  end
end
