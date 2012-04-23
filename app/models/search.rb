class Search < ActiveRecord::Base
  has_many :links
  
  def has_featured_link?
    featured_link_id!=nil
  end
  
  def been_run?
    self.last_id != nil && self.last_id != nil
  end

  def update_results
    new_tweets = latest_results
    found_links_count = save_tweeted_links(new_tweets)
    found_links_count
  end
  
  private 
    
    def latest_results
      # grab latest results
      # if search run before, only grab new results
      if been_run? 
        results = Twitter.search(query, :since_id=>self.last_id, :rpp=>100, :include_entities=>true)
      else 
        results = Twitter.search(query, :rpp=>100, :include_entities=>true)
      end
      # update last ID in model and only update last ID if results were received
      logger.info "Ran Twitter search for" + query
      update_attribute(:last_id, results.first.id) if results.count > 0
      # return list of tweets
      return results
    end
    
    def save_tweeted_links tweets
      logger.info "Trying to find links in " + tweets.count.to_s
      saved_links = 0
      tweets.each do |tweet|
        links = tweet.expanded_urls
        if links != nil
          links.each do |link_url|
            existing_link = Link.find_by_url(link_url)
            if existing_link == nil
              new_link = Link.new
              new_link.url = link_url
              new_link.frequency = 1
              new_link.add_source(tweet.from_user)
              new_link.search_id = id
              new_link.first_tweeted = tweet.created_at
              new_link.moderation_status = :new
              new_link.save
            else
              existing_link.frequency = existing_link.frequency + 1
              existing_link.add_source(tweet.from_user)
              existing_link.search_id = id
              existing_link.save
            end
            saved_links = saved_links + 1
          end
        end
      end
      saved_links
    end
  
end
