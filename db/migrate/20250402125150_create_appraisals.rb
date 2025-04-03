class CreateAppraisals < ActiveRecord::Migration[7.2]
  def change
    create_table :appraisals do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
