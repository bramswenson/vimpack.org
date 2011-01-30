module Jsonables

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    
    attr_accessor :jsonables

    def jsonable(name, options)
      self.jsonables ||= Hash.new
      self.jsonables[name.to_sym] = options
      self.setup_as_json(name.to_sym) if options.delete(:default)
      define_method name do
        self.to_json(self.class.jsonables[name.to_sym])
      end
    end

    protected

      def setup_as_json(name)
        define_method :as_json do |options|
          options ? super(options) :
                    super(self.class.jsonables[name.to_sym])
        end
      end

  end
end
