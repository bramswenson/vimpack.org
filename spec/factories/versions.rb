# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :version do
    script { FactoryGirl.create(:script) }
    author { FactoryGirl.create(:author) }
    filename { Faker::Lorem.words(1).join }
    script_version { Factory.next(:script_version) }
    date { Date.today }
    vim_version "7.2"
    release_notes { Faker::Lorem.words(20).join }
  end
  factory :pathogen_version, :parent => :version do
    script { FactoryGirl.create(:pathogen) }
    author { FactoryGirl.create(:timpope) }
    filename 'pathogen.vim'
    script_version { Factory.next(:script_version) }
    date '2008-12-25'
    vim_version '7.2'
    release_notes 'Pathogen..dead simple vim runtimepath management'
  end
end
