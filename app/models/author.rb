require 'jsonables'
class Author < ActiveRecord::Base
  include ::Jsonables
  has_many :versions
  has_many :scripts, :through => :versions

  validates :user_id, :user_name, :presence => true, :uniqueness => true

  jsonable :simple, :except  => [ :id, :created_at, :updated_at ], 
                    :default => true
end
