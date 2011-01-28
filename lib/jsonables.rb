module Jsonables

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    
    attr_accessor :jsonables

    def jsonable(name, options)
      self.jsonables ||= Hash.new
      self.jsonables[name.to_sym] = options
      define_method name do
        self.to_json(self.class.jsonables[name.to_sym])
      end
    end

  end

end
