class AddAppraisalToEntries < ActiveRecord::Migration[7.2]
  def change
    add_reference :entries, :appraisal, null: false, foreign_key: true
  end
end
