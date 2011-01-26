require 'spec_helper'

describe Author do
  before(:each) do
    @author = Factory(:timpope)
    @author.should be_valid
  end

  context "should not be valid without" do
    %w{ user_id user_name first_name last_name }.each do |attr|
      it attr do
        @author.send("#{attr}=".to_sym, nil)
        @author.should_not be_valid 
      end
    end
  end
  context ".as_json" do
    it "should return json" do
      JSON.pretty_generate(
        JSON.parse(@author.to_json)
      ).should == JSON.pretty_generate(JSON.parse(%Q{{
       "email": "vimNOSPAM@tpope.com",
       "first_name": "Tim",
       "homepage": "http://tpo.pe/",
       "last_name": "Pope",
       "user_id": 1331,
       "user_name": "tpope"
      }}))
    end
  end
end
