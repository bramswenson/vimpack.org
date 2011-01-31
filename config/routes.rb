require 'jsonables'
VimpackOrg::Application.routes.draw do
  scope '/api' do
    scope '/v1' do
      get '/scripts/search/:q' => 'scripts#search', :q => /.*/
      get '/scripts/:name' => 'scripts#show', :name => /[a-zA-Z\.]+/
      get '/scripts/:name/:jsonable' => 'scripts#show', :name => /[a-zA-Z\.]+/,
        :defaults => { :jsonable => :simple }, :constraints => Jsonables::RoutingConstraint.new(Script)
    end
  end
end
