# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  # Activate the gem you are reporting the issue against.
  gem "activerecord", "~> 7.1.0"
  gem 'benchmark-ips'
  gem 'mysql2'
end

require "active_record"
require "minitest/autorun"
require "logger"
require 'benchmark/ips'

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "mysql2", database: "test", port: 13306, host: '127.0.0.1', username: 'root')
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = :info

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name, null: false
    t.string :age, null: false
    t.timestamps
  end

  create_table :permissions, force: true do |t|
    t.string :action, null: false
    t.string :resource_type, null: false
    t.references :user, null: false, foreign_key: false, index: false
  end

  create_table :blogs, force: true do |t|
    t.string :title, null: false
    t.string :description, null: false
  end

  create_table :articles, force: true do |t|
    t.string :title, null: false
    t.string :content, null: false
    t.references :blog, null: false, foreign_key: false, index: false
    t.timestamps
  end

  create_table :categories, force: true do |t|
    t.string :name, null: false
    t.timestamps
  end
end

class User < ActiveRecord::Base
  has_many :permissions
end

class Permission < ActiveRecord::Base
  belongs_to :user
end

class Article < ActiveRecord::Base
end

class Category < ActiveRecord::Base
end
