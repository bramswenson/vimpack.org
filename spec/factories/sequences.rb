def random_numbers(count=3)
  count.to_i.times.inject('') do |n|
    n << rand(9)
    n
  end.to_i
end

Factory.sequence :script_version do |s|
  3.times.inject('') do |v, i|
    v << rand(9).to_s
    v << '.' unless i == 3
    v
  end  
end

Factory.sequence :script_id do |s| random_numbers(4) end
Factory.sequence :user_id   do |s| random_numbers(4) end
