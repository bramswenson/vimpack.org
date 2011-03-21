require 'sunspot/rails/spec_helper'

#RSpec.configure do |config|
  #config.before(:each) do
  #  ::Sunspot.session = ::Sunspot::Rails::StubSessionProxy.new(::Sunspot.session)
  #end

  #config.after(:each) do
  #  ::Sunspot.session = ::Sunspot.session.original_session
  #end
#end

def setup_sunspot_server
  $original_sunspot_session = Sunspot.session
  unless $sunspot_server
    puts "STARTING SOLR..."
    $sunspot_server = Sunspot::Rails::Server.new
    pid = fork { $sunspot_server.run }
    puts "WAITING FOR SOLR 20 SECONDS..."
    sleep 30 # allow some time for the instance to spin up
    puts "SOLR STARTED"
    # shut down the Solr server
    at_exit do
      puts "STOPPING SOLR..."
      `ps ax|egrep "solr.*test"|grep -v grep|awk '{print $1}'|xargs kill`
      sleep 4
      puts "SOLR STOPPED"
    end
  end
  Sunspot.session = $original_sunspot_session
end

# make sure that pickle calls #index! on our appropriate models
# clean out the Solr index after each scenario
def clean_sunspot_index
  begin
    Script.remove_all_from_index!
  rescue => e
    puts "REMOVE INDEX FAILED: #{e.message}"
  end
end

