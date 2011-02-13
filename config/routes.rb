require 'jsonables'
VimpackOrg::Application.routes.draw do
  scope '/api' do
    scope '/v1' do
      get '/scripts/search/:q' => 'scripts#search', :q => /.*/, :defaults => { :format => :json }
      get '/scripts/:name' => 'scripts#show', :name => /[a-zA-Z\.]+/, :defaults => { :format => 'json' }
      get '/scripts/:name/:jsonable' => 'scripts#show', :name => /[a-zA-Z\.]+/,
        :defaults => { :jsonable => :simple, :format => :json }, 
	:constraints => Jsonables::RoutingConstraint.new(Script)
    end
  end
end
