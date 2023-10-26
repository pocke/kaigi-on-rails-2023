# frozen_string_literal: true

require_relative '../base'

500.times do |i|
  Article.create!(title: "Hello#{i}", content: "World#{i}", blog_id: i % 50)
end

def a
  Article.all.exists?(blog_id: 42)
end

def b
  Article.all.any? { _1.blog_id == 42 }
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

ActiveRecord::Base.logger.level = :debug

puts "------ A ------"
a
puts "------ B ------"
b
