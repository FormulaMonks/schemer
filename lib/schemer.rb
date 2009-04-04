require 'activerecord'

module Schemer
  def schema(*args)
    extend  ClassMethods
    include InstanceMethods
    
    class_inheritable_accessor :schema_columns
    self.schema_columns = args.collect(&:to_s)
  end

  module ClassMethods
    # Columns which we don't touch regardless of not being defined in schema
    # (and are ignored if they are defined in schema)
    def protected_columns
      %w( id )
    end

    # Create the underlying table for this class
    def create_table
      ActiveRecord::Migration.create_table(table_name) do |t|;end;
    end
    
    # Update ActiveRecord's automatically generated methods so we don't have to
    # reload for schema changes to take effect
    def update_methods
      generated_methods.each { |method| remove_method(method) }
      @columns = @column_names = @columns_hash = @generated_methods = nil
    end
    
    # Update the underlying schema as defined by schema call
    def update_schema
      create_table unless table_exists?
      (schema_columns - column_names).each { |column| ActiveRecord::Migration.add_column(table_name, column, :string) }
      (column_names - protected_columns - schema_columns).each { |column| ActiveRecord::Migration.remove_column(table_name, column) }
    end    
  end
  
  module InstanceMethods
    def initialize(*args)
      self.class.update_schema
      self.class.update_methods
      super
    end
  end
end

ActiveRecord::Base.extend(Schemer)
