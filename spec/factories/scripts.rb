# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :script do
    script_id { Factory.next(:script_id) }
    display_name { Faker::Lorem.words(1).join }
    summary { Faker::Lorem.sentence }
    name { display_name }
    script_type { Script::SCRIPT_TYPES[rand(Script::SCRIPT_TYPES.size)] }
    description { Faker::Lorem.sentence }
    install_details { Faker::Lorem.sentence }
  end
  factory :pathogen, :parent => :script do
    script_id 2332
    display_name 'pathogen.vim'
    name 'pathogen.vim'
    summary 'Pathogen...simple but effective'
    script_type 'utility'
    description 'Pathogen...simple but effective for good use'
    install_details 'http://vimpack.org/'
  end
end
