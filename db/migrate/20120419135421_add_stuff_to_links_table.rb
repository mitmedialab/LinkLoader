class AddStuffToLinksTable < ActiveRecord::Migration
  def change
    add_column :links, :moderation_status, :string
    add_column :links, :first_tweeted, :datetime
  end
end
