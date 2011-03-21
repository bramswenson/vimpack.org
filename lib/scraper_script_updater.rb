module ScraperScriptUpdater
  
  module FromScraperJson

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def from_scraper_file(filename)
        self.from_scraper_json(File.open(filename, 'r').read)
      end

      def from_scraper_json(json_input)
        begin
          input = JSON.parse(json_input)
        rescue => e
          Rails.logger.error("There was an error parsing the json file: #{e.message}")
          Rails.logger.error(e.backtrace)
        end
        versions = input.delete('versions')
        script = Script.find_or_initialize_by_name(input['name'], input)
        if script.new_record?
          script.save!
          Rails.logger.info("Script created: #{script.display_name}")
        else
          Rails.logger.info("Script exists: #{script.display_name}")
        end
        versions.each do |version_input|
          version_input.delete('url')
          author_input = version_input.delete('author')
          author = Author.find_or_initialize_by_user_name(author_input['user_name'], author_input)
          if author.new_record?
            author.save!
            Rails.logger.info("Author created: #{author.user_name}")
          else
            Rails.logger.info("Author exists: #{author.user_name}")
          end
          version = Version.find_or_initialize_by_script_id_and_script_version(
            script.id, version_input['script_version'], version_input.merge!(:author => author)
          )
          if version.new_record?
            version.save!
            Rails.logger.info("Version created: #{version.script_version}")
          else
            Rails.logger.info("Version exists: #{version.script_version}")
          end
        end
        script
      end
    end
  end

  class Runner
    REPO_URL = 'git://github.com/vim-scraper/scripts.git'
    REPO_DIR = File.join('/tmp', 'scripts-repo')

    def clone_repo
      # clone/update git scripts repo
      if File::directory?(REPO_DIR)
        system("cd #{REPO_DIR}; git pull origin master")
      else
        system("git clone #{REPO_URL} #{REPO_DIR}")
      end
    end

    def scan_scripts
      # for each .json file Script.from_json
      Dir.glob("#{REPO_DIR}/*.json").each do |script_file|
        Script.from_scraper_file(script_file)
      end
    end

    def run!
      clone_repo
      scan_scripts
    end

    def self.run!
      self.new.run!
    end

  end
end
