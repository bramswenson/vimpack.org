class Author < ActiveRecord::Base
  has_many :versions
  has_many :scripts, :through => :versions

  validates :user_id, :user_name, :first_name, :last_name, :presence => true
  def as_json(options=nil, *args)
    options ||= {}
    options.reverse_merge!(:except  => [ :id, :created_at, :updated_at ])
    super(options, *args)
  end
end
