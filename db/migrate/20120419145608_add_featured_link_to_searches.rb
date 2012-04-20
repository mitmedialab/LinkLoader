class AddFeaturedLinkToSearches < ActiveRecord::Migration
  def change
    add_column(:searches, :featured_link_id, :integer)
  end
end
