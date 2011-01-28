VimpackOrg::Application.routes.draw do
  scope '/api' do
    scope '/v1' do
      get '/scripts/:name' => 'scripts#show', :name => /[a-zA-Z\.]+/
      get '/scripts/:name/:jsonable' => 'scripts#show', :name => /[a-zA-Z\.]+/, :defaults => { :jsonable => :simple }
    end
  end
end
