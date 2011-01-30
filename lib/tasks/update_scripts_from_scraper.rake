namespace :utils do
  desc "Update the scripts from the scraper"
  task :update_scripts_from_scraper, :needs => :environment do
    Script::ScraperScriptUpdater::Runner.run!
  end
end
