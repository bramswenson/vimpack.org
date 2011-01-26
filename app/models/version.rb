class Version < ActiveRecord::Base
  belongs_to :script
  belongs_to :latest_for, :class_name => 'Script'
  belongs_to :author
  validates :script_id, :script_version, :date, :author_id, :presence => true
  validates :latest_for_id, :uniqueness => true, :allow_nil => true
  attr_accessor :setting_latest_version
  after_save :set_latest_version!

  def as_json(options=nil, *args)
    options ||= {}
    options.reverse_merge!(:except  => [ :id, :created_at, :updated_at, 
                                         :latest_for_id, :script_id, 
                                         :author_id ],
                           :include => [ :author ])
    super(options, *args)
  end
  
  private

    def set_latest_version!
      unless @setting_latest_version == true
        @setting_latest_version = true
        if script.latest_version
          unless script.latest_version.date > date
            script.update_attribute(:latest_version, self)
          end
        else
          script.update_attribute(:latest_version, self)
        end
        @setting_latest_version = false
      end
    end

end
