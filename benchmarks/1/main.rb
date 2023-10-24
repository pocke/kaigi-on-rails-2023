# frozen_string_literal: true

require_relative '../base'

500.times do |i|
  Article.create!(title: "Hello#{i}", content: "World#{i}", blog_id: i % 50)
end

def a
  Article
    .all
    .select { _1.blog_id == 42 } 
end

def b
  Article
    .all
    .where(blog_id: 42)
    .to_a
end

Benchmark.ips do |x|
  x.report("A") do
    a
  end

  x.report("B") do
    b
  end

  x.compare!
end
