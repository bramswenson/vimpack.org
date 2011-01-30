class JsonableConstraint
  def initialize(model)
    @model = model
  end
 
  def matches?(request)
    @model.jsonables.keys.include?(request.params[:jsonables])
  end
end

VimpackOrg::Application.routes.draw do
  scope '/api' do
    scope '/v1' do
      get '/scripts/:name' => 'scripts#show', :name => /[a-zA-Z\.]+/
      get '/scripts/:name/:jsonable' => 'scripts#show', :name => /[a-zA-Z\.]+/, 
        :defaults => { :jsonable => :simple }, :constraints => JsonableConstraint.new(Script)
    end
  end
end
