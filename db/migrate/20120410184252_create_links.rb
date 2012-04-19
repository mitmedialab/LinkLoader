class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :search_id
      t.string :url
      t.integer :frequency
      t.string :sources

      t.timestamps
    end
  end
end
