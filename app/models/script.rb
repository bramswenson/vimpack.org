class Script < ActiveRecord::Base
  SCRIPT_TYPES = %w{ utility colorscheme syntax }
  has_many :versions, :dependent => :destroy
  has_one  :latest_version, :foreign_key => :latest_for_id, :dependent => :destroy, :class_name => 'Version'
  has_many :authors, :through => :versions, :uniq => true, :dependent => :destroy

  validates :script_id, :display_name, :summary, :name, :description, 
            :presence => true
  validates :script_type, :presence => true, 
            :inclusion => { :in => SCRIPT_TYPES }

  def repo_url
    "http://github.com/vim-scripts/#{name}.git"
  end

  def script_url
    "http://www.vim.org/scripts/script.php?script_id=#{script_id}"
  end

  def latest
    latest_version.as_json
  end

  def self.from_json(json_input)
    begin
      input = JSON.parse(json_input)
    rescue => e
      Rails.logger.error("There was an error parsing the json file: #{e.message}")
      Rails.logger.error(e.backtrace)
    end
    versions = input.delete('versions')
    script = Script.create!(input)
    versions.each do |version_input|
      version_input.delete('url')
      author_input = version_input.delete('author')
      author = Author.find_or_initialize_by_user_name(author_input['user_name'], author_input)
      author.save! if author.new_record?
      Version.create!(version_input.merge(:author => author, :script => script))
    end
    script
  end

  def as_json(options=nil, *args)
    options ||= {}
    options.reverse_merge!(:except  => [ :id, :created_at, :updated_at ],
                           :methods => [ :repo_url, :script_url, :url, :latest ]) 
    super(options, *args)
  end
end
