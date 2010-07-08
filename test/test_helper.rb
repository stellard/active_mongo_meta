require 'rubygems'
require 'active_support'
require 'active_record'
require 'active_support/test_case'
require 'shoulda'
require 'ruby-debug'
require 'mongo_mapper'

ENV['RAILS_ENV'] = 'test' 
require File.dirname(__FILE__) + '/../rails/init'
Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

MongoMapper.database = "lfgdsgs"

ActiveRecord::Base.logger = Logger.new('/tmp/debug.log')
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => '/tmp/active_mongo_meta.sqlite')
ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/schema.rb")


class Test::Unit::TestCase
  # Drop all collections after each test case.
  def teardown
    MongoMapper.database.collections.each {|collection| collection.drop unless collection.name =~ /(.*\.)?system\..*/  }
  end
  
  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do 
      super
    end
  end
  
  def eql_arrays?(first, second)
    first.collect(&:_id).to_set == second.collect(&:_id).to_set
  end
end

