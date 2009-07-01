require 'rubygems'
require 'contest'
require File.join(File.dirname(__FILE__), '..', 'lib', 'schemer')

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'test/schemer_test.db'
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))

class Foo < ActiveRecord::Base;end;
ActiveRecord::Migration.drop_table(Foo.table_name) if Foo.table_exists?

class FooTest < Test::Unit::TestCase  
  context "defining the schema" do
    setup do
      Foo.schema :foo, :bar
    end
    
    should "create the foos table" do
      assert Foo.table_exists?
    end
    
    context "with an instance" do
      setup do
        @foo = Foo.new
      end
      
      should "create the foo column" do
        assert @foo.respond_to?(:foo)
      end

      should "create the bar column" do
        assert @foo.respond_to?(:bar)
      end
    end    
  end
  
  context "updating the schema" do
    setup do
      Foo.schema :foo, :bar
      Foo.schema :foo
      @foo = Foo.new
    end
    
    should "remove the bar column" do
      assert !@foo.respond_to?(:bar)
    end
  end
end
