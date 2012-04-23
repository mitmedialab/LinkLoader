class ChangeSearchLastIdToString < ActiveRecord::Migration
  def change
    change_column :searches, :last_id, :string
  end
end
