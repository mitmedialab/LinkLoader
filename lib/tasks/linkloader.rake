namespace :linkloader do
	
	task :update =>:environment do
    Rails::logger.info("")
    Search.update_all
  end

end