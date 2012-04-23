namespace :linkloader do
	
	task :update =>:environment do
    Rails::logger.info("")
    Rails::logger.info("Starting to update all active searches:")
    Search.all.each do |s|
      if s.active?
        links_found = s.update_results
        Rails::logger.info("  Updated search results for #{s.query} - got #{links_found} reults")
      else 
        Rails::logger.info("  Skipping inactive search #{s.query}")
      end
    end
    Rails::logger.info("done updating all active searches")
  end

end