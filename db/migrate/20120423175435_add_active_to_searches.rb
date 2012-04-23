class AddActiveToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :active, :boolean, :default => 0
  end
end
