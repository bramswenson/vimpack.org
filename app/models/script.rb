require 'jsonables'
require 'scraper_script_updater'
class Script < ActiveRecord::Base
  include Jsonables
  include ScraperScriptUpdater::FromScraperJson
  SCRIPT_TYPES = [ 'utility', 'color scheme', 'syntax', 'ftplugin', 'indent', 
                   'game', 'plugin', 'patch' ]
  has_many :versions, :dependent => :destroy
  has_one  :latest_version, :foreign_key => :latest_for_id, :dependent => :destroy, :class_name => 'Version'
  has_many :authors, :through => :versions, :uniq => true, :dependent => :destroy

  validates :script_id, :display_name, :name, :presence => true, :uniqueness => true
  validates :script_type, :presence => true, 
            :inclusion => { :in => SCRIPT_TYPES }

  jsonable :simple,  :only =>    [ :name, :script_type, :summary ],
                     :methods => [ :repo_url, :version ], :default => true
  jsonable :current, :except =>  [ :id, :created_at, :updated_at ],
                     :methods => [ :repo_url, :script_url, :url, :latest ]

  def repo_url
    "http://github.com/vim-scripts/#{name}.git"
  end

  def script_url
    "http://www.vim.org/scripts/script.php?script_id=#{script_id}"
  end

  def latest
    latest_version.as_json
  end

  def version
    return latest_version.script_version
  end

end
