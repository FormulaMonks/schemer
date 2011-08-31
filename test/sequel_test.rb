require File.join(File.dirname(__FILE__), "test_helper")

require "schemer/sequel"

$db = Sequel.sqlite(File.join(OUTPUT, "schemer_sequel_test.db"))
$db.drop_table(:foos) if $db.table_exists?(:foos)
$db.drop_table(:bars) if $db.table_exists?(:bars)

class SequelTest < Test::Unit::TestCase
  class Foo < Sequel::Model
    plugin Schemer::Sequel
  end

  class Bar < Sequel::Model
    plugin Schemer::Sequel
  end
  
  setup do
    Foo.schema
    Bar.schema
  end
  
  context "defining the schema" do
    setup do
      Foo.schema :foo, :bar
    end
    
    should "create the foos table" do
      assert Foo.db.table_exists?(Foo.table_name)
    end
    
    should "define the columns on the table" do
      assert_equal :foo, $db.schema(:foos)[1][0]
      assert_equal :bar, $db.schema(:foos)[2][0]
    end
    
    should "refresh the schema on the model" do
      @foo = Foo.create :foo => "foo", :bar => "bar"
      
      assert_equal "foo", @foo.foo
      assert_equal "bar", @foo.bar
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
      @foo = Foo[Foo.create(:foo => "5", :bar => 5).id]
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
      foo = Foo[Foo.create(:foo => "5", :bar => "5").id]
      assert_equal 5, foo.foo
    end
  end
  
  context "building a migration" do
    setup do
      Foo.schema :foo, { :bar => :integer }
    end
    
    should "output the migration for Foo" do
      assert_equal(
%Q{create_table :foos do |t|
  add_column :foo, String
  add_column :bar, :integer
end}, Schemer::Sequel::Migrator.migration(Foo)
      )
    end
  end
end
