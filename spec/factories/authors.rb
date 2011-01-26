# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author do
    user_id { Factory.next(:user_id) }
    user_name { Faker::Internet.user_name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    homepage { Faker::Internet.domain_name }
  end
  factory :timpope, :parent => :author do
    user_id 1331
    user_name 'tpope'
    first_name 'Tim'
    last_name 'Pope'
    email 'vimNOSPAM@tpope.com'
    homepage 'http://tpo.pe/'
  end
end
