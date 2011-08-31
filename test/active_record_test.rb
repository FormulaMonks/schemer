require File.join(File.dirname(__FILE__), "test_helper")

require "schemer/active_record"

logger = Logger.new(File.join(OUTPUT, "debug.log"))
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => File.join(OUTPUT, "schemer_active_record_test.db")
ActiveRecord::Base.logger = logger

class ActiveRecordTest < Test::Unit::TestCase
  class Foo < ActiveRecord::Base;end;
  ActiveRecord::Migration.drop_table(Foo.table_name) if Foo.table_exists?
  class Bar < ActiveRecord::Base;end;
  ActiveRecord::Migration.drop_table(Bar.table_name) if Bar.table_exists?
  
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
  
  context "with types" do
    setup do
      Foo.schema :foo, { :bar => :integer }, :baz
      @foo = Foo.find(Foo.create!(:foo => "5", :bar => 5).id)
    end
    
    should "create foo, bar and baz columns" do
      assert @foo.respond_to?(:foo)
      assert @foo.respond_to?(:bar)
      assert @foo.respond_to?(:baz)
    end
    
    should "create bar column using integer datatype" do
      assert_equal 5, @foo.bar
    end
    
    should "create foo column using string datatype" do
      assert_equal "5", @foo.foo
    end
    
    should "recreate foo column as integer" do
      Foo.schema({ :foo => :integer }, { :bar => :integer }, :baz)
      foo = Foo.find(Foo.create!(:foo => "5", :bar => "5").id)
      assert_equal 5, foo.foo
    end
  end
  
  context "building a Rails migration" do
    setup do
      Foo.schema :foo, :bar
    end
    
    should "output the migration for Foo" do
      assert_equal(
%Q{create_table :foos do |t|
  t.string :foo
  t.string :bar
end}, Schemer::ActiveRecord::Migrator.migration(Foo)
      )
    end
  end
end
