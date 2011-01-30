# features/support/config.rb
# start the Solr server and give it a few seconds to initialize
require File.join(File.dirname(__FILE__), 'pickle')
module Pickle
  module Session

    def create_model_with_sunspot(a_model_name, fields = nil)
      result = create_model_without_sunspot(a_model_name, fields)

      model = model(a_model_name)
      model.index! if model.respond_to?(:index!)

      result
    end
    alias_method_chain :create_model, :sunspot

  end
end

$original_sunspot_session = Sunspot.session

Before("@sunspot") do
  unless $sunspot_server
    puts "STARTING SOLR..."
    $sunspot_server = Sunspot::Rails::Server.new
    pid = fork { $sunspot_server.run }
    puts "WAITING FOR SOLR 20 SECONDS..."
    sleep 20 # allow some time for the instance to spin up
    puts "SOLR STARTED"
    # shut down the Solr server
    at_exit do
      puts "STOPPING SOLR..."
      `ps ax|egrep "solr.*test"|grep -v grep|awk '{print $1}'|xargs kill`
      sleep 2
      puts "SOLR STOPPED"
    end
  end
  Sunspot.session = $original_sunspot_session
  #puts "INDEXING Script..."
  #Script.index!
  #puts "Script indexed"
end

# make sure that pickle calls #index! on our appropriate models
# clean out the Solr index after each scenario
After("@sunspot") do
  begin
    Script.remove_all_from_index!
  rescue => e
    puts "REMOVE INDEX FAILED: #{e.message}"
  end
end

Before("~@sunspot") do
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
end
