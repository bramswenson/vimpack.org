require 'spec_helper'

describe Version do

  context "should not be valid without" do
    before(:each) do
      @version = Factory(:version)
      @version.should be_valid
    end

    %w{ script_id script_version date author_id }.each do |attr|
      it attr do
        @version.send("#{attr}=".to_sym, nil)
        @version.should_not be_valid 
      end
    end
  end

  context ".set_latest_version!" do

    before(:each) do
      @version = Factory(:pathogen_version, :date => '2001-12-25')
      @version.should be_valid
      @version.save!
    end

    it "should set self as latest_version when unset" do
      @version.script.latest_version.should == @version
    end

    it "should set self as latest_version when newer version added" do
      @version2 = Factory.create(:version, :author => @version.author, 
                                 :script => @version.script, 
                                 :date => '2002-12-25')
      @version2.save!
      @version.script.latest_version.should == @version2
    end

    it "should do nothing when added version is older than latest_version when newer version added" do
      @version2 = Factory.create(:version, :author => @version.author, 
                                 :script => @version.script, 
                                 :date => '2002-12-25')
      @version2.save!
      @version3 = Factory.create(:version, :author => @version.author, 
                                 :script => @version.script, 
                                 :date => '1999-12-25')
      @version3.save!
      @version.script.latest_version.should == @version2
    end

  end

  context ".as_json" do

    before(:each) do
      @version = Factory(:pathogen_version, :script_version => '1.2')
      @version.should be_valid
    end

    it "should return json" do
      JSON.pretty_generate(
        JSON.parse(@version.to_json)
      ).should == JSON.pretty_generate(JSON.parse(%Q{{
        "date": "2008-12-25",
        "filename": "pathogen.vim",
        "release_notes": "Pathogen..dead simple vim runtimepath management",
        "script_version": "1.2",
        "vim_version": "7.2",
        "author": {
          "email": "vimNOSPAM@tpope.com",
          "first_name": "Tim",
          "homepage": "http://tpo.pe/",
          "last_name": "Pope",
          "user_id": 1331,
          "user_name": "tpope"
        }
      }}))
    end
  end
end
