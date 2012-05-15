class Search < ActiveRecord::Base
  has_many :links
  
  def has_featured_link?
    featured_link_id!=nil && featured_link_id!=0
  end
  
  def been_run?
    self.last_id != nil && self.last_id != ""
  end

  def update_results
    new_tweets = latest_results
    found_links_count = save_tweeted_links(new_tweets)
    found_links_count
  end
  
  def self.update_all
    Rails::logger.info("Starting to update all active searches:")
    self.all.each do |s|
      if s.active?
        links_found = s.update_results
        Rails::logger.info("  Updated search results for #{s.query} - got #{links_found} reults")
      else 
        Rails::logger.info("  Skipping inactive search #{s.query}")
      end
    end
    Rails::logger.info("done updating all active searches")
  end
  
  private 
    def latest_results
      results = []
      if self.category == "Search"
        results = latest_search_results 
      elsif self.category == "List"
        results = latest_list_results
      end
      # update last ID in model and only update last ID if results were received
      logger.info "Ran Twitter search for" + query
      update_attribute(:last_id, results.first.id) if results.count > 0
      # return list of tweets
      return results
    end
    
    def latest_list_results
      # split query into username and listname
      query_parts = self.query.split('/')
      username = query_parts.first
      listname = query_parts.second
      # get new results from list
      if been_run? 
        results = Twitter.list_timeline(username, listname, :per_page=>100, :since_id=>self.last_id, :include_entities=>true)
      else 
        results = Twitter.list_timeline(username, listname, :per_page=>100, :include_entities=>true)
      end
      return results
    end
    
    def latest_search_results
      # grab latest results from a search
      # if search run before, only grab new results
      if been_run? 
        results = Twitter.search(query, :since_id=>self.last_id, :rpp=>100, :include_entities=>true)
      else 
        results = Twitter.search(query, :rpp=>100, :include_entities=>true)
      end
      return results
    end
    
    def save_tweeted_links tweets
      logger.info "Trying to find links in " + tweets.count.to_s
      saved_links = 0
      tweets.each do |tweet|
        links = tweet.expanded_urls
        # this works if it's a Search
        user = tweet.from_user
        # this works if it's a List
        user = tweet.user.screen_name if user == nil
        if links != nil
          links.each do |link_url|
            cleaned_link_url = link_url.downcase
            existing_link = Link.find_by_url(cleaned_link_url)
            if existing_link == nil
              new_link = Link.new
              new_link.url = cleaned_link_url
              new_link.frequency = 1
              new_link.add_source(user)
              new_link.search_id = id
              new_link.first_tweeted = tweet.created_at
              new_link.moderation_status = :new
              new_link.save
            else
              existing_link.frequency = existing_link.frequency + 1
              existing_link.add_source(user)
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
