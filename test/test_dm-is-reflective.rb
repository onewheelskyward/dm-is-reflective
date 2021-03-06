
if respond_to?(:require_relative, true)
  require_relative 'abstract'
else
  require File.dirname(__FILE__) + '/abstract'
end

TestCase = begin
             require 'minitest/unit'
             MiniTest::Unit.autorun
             MiniTest::Unit::TestCase
           rescue LoadError
             require 'test/unit'
             Test::Unit::TestCase
           end

%w[sqlite postgres mysql].each{ |adapter|
  begin
    require "dm-#{adapter}-adapter"
  rescue LoadError
    puts "skip #{adapter} test since it's not installed"
  end
}

# cost 1 second to run
class SqliteTest < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite::memory:')

  end
end if defined?(DataMapper::Adapters::SqliteAdapter)

class SqliteHashSetupTest < TestCase
  include Abstract
  def setup_data_mapper
    DataMapper.setup(:default, :adapter => 'sqlite', :database => ':memory:')
  end
end if defined?(DataMapper::Adapters::SqliteAdapter)

# cost 2 seconds to run
class PostgresTest < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'postgres://dm_is_reflective:godfat@localhost/dm_is_reflective')
  end
end if defined?(DataMapper::Adapters::PostgresAdapter)

# cost 8 seconds to run (what the hell??)
class MysqlTest < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm_is_reflective:godfat@localhost/dm_is_reflective')
  end
end if defined?(DataMapper::Adapters::MysqlAdapter)
