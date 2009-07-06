module Schemer
  class Migrator
    class << self
      # Outputs the Rails migration for the schema defined in the given class.
      # 
      # Outputs an empty string if no schema is defined on the class.
      def migration(klass)
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