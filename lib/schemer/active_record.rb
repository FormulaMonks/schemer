require "active_record"

module Schemer
  module ActiveRecord
    def schema(*args)
      extend ClassMethods
      
      class_inheritable_accessor :schema_columns
      self.schema_columns = {}
      args.collect{ |a| a.is_a?(Hash) ? a.stringify_keys : { a.to_s => :string } }.each do |column|
        self.schema_columns.merge!(column)
      end

      update_schema
      update_methods
    end

    module ClassMethods
      # Columns which we don't touch regardless of not being defined in schema
      # (and are ignored if they are defined in schema)
      def protected_columns
        %w( id )
      end
    
      # Create the underlying table for this class
      def create_table
        ::ActiveRecord::Migration.suppress_messages do
          ::ActiveRecord::Migration.create_table(table_name) do |t|;end;
        end
      end
    
      # Update ActiveRecord's automatically generated methods so we don't have to
      # reload for schema changes to take effect
      def update_methods
        undefine_attribute_methods
        @columns = @column_names = @columns_hash = @generated_methods = nil
      end
    
      # Update the underlying schema as defined by schema call
      def update_schema
        create_table unless table_exists?

        columns.reject{ |column| protected_columns.include?(column.name) }.each do |column|
          if !schema_columns.has_key?(column.name)
            # remove any extraneous columns
            migrate_quietly{ ::ActiveRecord::Migration.remove_column(table_name, column.name) }
          elsif column.type != schema_columns[column.name]
            # change any columns w/ wrong type
            migrate_quietly{ ::ActiveRecord::Migration.change_column(table_name, column.name, schema_columns[column.name]) }
          end
        end

        # add any missing columns
        (schema_columns.keys - column_names).each do |column|
          migrate_quietly{ ::ActiveRecord::Migration.add_column(table_name, column, schema_columns[column]) }
        end
      end
      
      def migrate_quietly(&block)
        ::ActiveRecord::Migration.suppress_messages do
          yield
        end
      end
    end
    
    class Migrator
      # Outputs the Rails migration for the schema defined in the given class.
      # 
      # Outputs an empty string if no schema is defined on the class.
      def self.migration(klass)
        return nil unless klass.respond_to?(:schema_columns)

        "create_table :#{klass.table_name} do |t|\n" +
        (klass.schema_columns.keys - klass.protected_columns).collect do |column| 
          "  t.#{klass.schema_columns[column]} :#{column}"
        end.join("\n") +
        "\nend"
      end
    end    
  end
end

ActiveRecord::Base.extend(Schemer::ActiveRecord)
