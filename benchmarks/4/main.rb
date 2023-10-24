# frozen_string_literal: true

require_relative '../base'

100.times do |i|
  Category.create!(name: "Category#{i}")
end
200.times do |i|
  Article.create!(title: "Hello#{i}", content: "World#{i}", blog_id: i)
end

def outside_loop
  categories = Category.all.to_a

  _ = response = Article.all.map do
    {
      title: _1.title, 
      categories:,
    }
  end
end

def inside_loop
  _ = response = Article.all.map do
    categories = Category.all.to_a

    {
      title: _1.title, 
      categories:,
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
