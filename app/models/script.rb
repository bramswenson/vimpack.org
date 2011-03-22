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

  validates :display_name, :name, :presence => true, :uniqueness => true
  validates :script_id, :presence => true, :numericality => true
  validates :script_type, :presence => true, 
            :inclusion => { :in => SCRIPT_TYPES }

  jsonable :simple, :only =>    [ :name, :script_type, :summary ],
                    :methods => [ :repo_url, :script_version ], 
                    :default => true
  jsonable :info,   :only =>    [ :name, :script_type, :description, :summary ],
                    :methods => [ :repo_url, :author, :script_version ]

  searchable :auto_index => true, :auto_remove => true do
    text   :name,        :default_boost => 4
    text   :summary
    text   :script_id
    string :name
    string :script_type
  end

  def repo_url
    "http://github.com/vim-scripts/#{name}.git"
  end

  def script_url
    "http://www.vim.org/scripts/script.php?script_id=#{script_id}"
  end

  def author
    self.latest_version.author.user_name
  end

  delegate :script_version, :to => :latest_version

  def self.limited_search(params)
    params[:limit] ||= 100
    params[:page]  ||= 1
    script_types = params[:script_type].blank? ? Array.new : params[:script_type].split(',')
    script_types = script_types.map { |st| st.gsub('_', ' ') }
    Script.search do
      keywords(params[:q]) unless params[:q].blank?
      with(:script_type).any_of script_types unless script_types.empty?
      order_by(:name, :asc)
      paginate(:page => params[:page], :per_page => params[:limit])
    end.results.map(&:simple_attributes)
  end

end
