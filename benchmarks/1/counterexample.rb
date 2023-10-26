require_relative '../base'
require_relative './base'

500.times do |i|
  Article.create!(title: "Hello#{i}", content: "World#{i}", blog_id: i % 50, is_active: false)
end

undef a
def a
  articles = Article.all
  _ = x = articles.select {
    _1.is_active
  }
  _ = y = articles.select {
    not _1.is_active
  }
end

undef b
def b
  _ = x = Article
    .where(is_active: true)
    .to_a
  _ = y = Article
    .where(is_active: false)
    .to_a
end

Benchmark.ips do |x|
  x.report('A') { a }
  x.report('B') { b }
  x.compare!
end

ActiveRecord::Base.logger.level = :debug

puts '------ A ------'
a

puts '------ B ------'
b
