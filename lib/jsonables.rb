module Jsonables

  class RoutingConstraint
    def initialize(model)
      @model = model
    end
   
    def matches?(request)
      res = @model.jsonables.keys.include?(request.params[:jsonable].to_sym)
      Rails.logger.debug("Routing constraint matches <#{res}>: request.params[:jsonable]")
      res
    end
  end

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
      define_method "#{name}_attributes".to_sym do
        JSON.parse(self.to_json(self.class.jsonables[name.to_sym]))
      end
    end

    protected

      def setup_as_json(name)
        define_method :as_json do |options=nil|
          options ? super(options) :
                    super(self.class.jsonables[name.to_sym])
        end
      end

  end
end
