# frozen_string_literal: true

require_relative '../base'

User.create!(id: 42, name: "John", age: 100)
500.times do |i|
  Permission.create!(action: :update, user_id: i, resource_type: "Article")
end
200.times do |i|
  Article.create!(title: "Hello#{i}", content: "World#{i}", blog_id: i)
end

def outside_loop
  current_user = User.find(42)

  can_update = current_user
    .permissions
    .exists?(action: :update)

  _ = response = Article.all.map do
    {
      title: _1.title, 
      can_update:,
    }
  end
end

def inside_loop
  current_user = User.find(42)

  _ = response = Article.all.map do
    can_update = current_user
      .permissions
      .exists?(action: :update)

    {
      title: _1.title, 
      can_update:,
    }
  end
end

Benchmark.ips do |x|
  x.report("outside loop - no cache") do
    outside_loop
  end
  x.report("inside loop - no cache") do
    inside_loop
  end
  x.report("outside loop - cache") do
    ActiveRecord::Base.cache do
      outside_loop
    end
  end
  x.report("inside loop - cache") do
    ActiveRecord::Base.cache do
      inside_loop
    end
  end

  x.compare!
end

ActiveRecord::Base.logger.level = :debug

puts "------ A ------"
ActiveRecord::Base.cache { outside_loop }
puts "------ B ------"
ActiveRecord::Base.cache { inside_loop }
