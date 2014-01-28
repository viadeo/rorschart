require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require 'date'
require 'active_record'
require "sqlite3"

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)