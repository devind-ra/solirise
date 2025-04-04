class RemoveLinkFromEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :entries, :link, :string
  end
end
