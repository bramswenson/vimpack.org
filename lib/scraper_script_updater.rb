module ScraperScriptUpdater
  
  module FromScraperJson

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def from_scraper_file(filename)
        self.from_scraper_json(File.open(filename, 'r').read)
      end

      def parse_scraper_json(scraper_json)
        begin
          JSON.parse(scraper_json)
        rescue => e
          Rails.logger.error("There was an error parsing the json file: #{e.message}")
          Rails.logger.error(e.backtrace)
        end
      end

      def create_or_update_model(model, key, data)
        instance = model.send("find_by_#{key}", data[key])||model.new(data)
        results = if instance.new_record?
          Rails.logger.info("Attempting to create #{model.name}: #{instance.inspect}")
          instance.save
        else
          Rails.logger.info("Attempting to update #{model.name}: #{instance.inspect}")
          instance.update_attributes(data)
        end
        if results == true
          instance
        else
          instance.valid?
          Rails.logger.error("create_or_update_model failure: #{model.name} : #{data[key]}")
          Rails.logger.error("model errors: #{instance.errors.inspect}")
          raise StandardError.new("create_or_update_model failure: #{model.name} : #{data[key]}")
        end
      end

      def create_or_update_versions_and_authors_for_script(versions, script)
        versions.each do |version_data|
          version_data.delete('url')
          author = create_or_update_model(Author, 'user_name', version_data.delete('author'))
          version_data.merge!(:author => author, :script => script)
          version = create_or_update_model(script.versions, 'script_version', version_data)
        end
      end

      def from_scraper_json(scraper_json)
        script_data = parse_scraper_json(scraper_json)
        versions = script_data.delete('versions')
        script = create_or_update_model(Script, 'name', script_data)
        create_or_update_versions_and_authors_for_script(versions, script)
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
