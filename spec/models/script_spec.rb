require 'spec_helper'

describe Script do

  context "should not be valid" do
    before(:each) do
      Script.destroy_all
      @script = Factory(:script)
      @script.should be_valid
    end
    context "without" do
      %w{ script_id display_name name script_type }.each do |attr|
        it attr do
          @script.send("#{attr}=".to_sym, nil)
          @script.should_not be_valid 
        end
      end
    end
    it "when script_type is not one of SCRIPT_TYPES" do
      @script.script_type = 'yunotestucode'
      @script.should_not be_valid
    end
  end

  context "should provide a url for the" do
    before(:each) do
      @script = Factory(:script)
      @script.should be_valid
    end
    %w{ repo script }.each do |key|
      url_name = "#{key}_url"
      it key do
        @script.send(url_name.to_sym).should match(/http(s?):\/\//)
      end
    end
  end

  context "Script.from_scraper_json" do
    before(:all) do
      file = File.read(Rails.root.join('public', 'json', '2332-pathogen.vim.json'))
      @script_from_file = Script.from_scraper_json(file)
    end
    context "should return a script instance" do
      it "that is saved" do
        @script_from_file.should_not be_new_record
      end
      it "that has 1 author" do
        @script_from_file.authors.count.should == 1
        Author.count.should == 1
      end
      it "that has 3 versions" do
        @script_from_file.versions.count.should == 3
        Version.count.should == 3
      end
    end
  end

  context ".as_json" do

    before(:each) do
      Script.destroy_all
      Author.destroy_all
      Version.destroy_all
      @version = Factory.create(:pathogen_version, :script_version => '1.2')
      @script = @version.script
    end

    it "should return json" do
      JSON.pretty_generate(
        JSON.parse(@script.to_json)
      ).should == JSON.pretty_generate(JSON.parse(%Q{{
        "name": "pathogen.vim",
        "script_type": "utility",
        "summary": "Pathogen...simple but effective",
        "repo_url": "http://github.com/vim-scripts/pathogen.vim.git",
        "version": "1.2"
      }}))
    end
  end
end
