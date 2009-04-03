module Schemer
  def self.schema(*args)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
    
    schema_columns = args.collect(&:to_s)
  end

  module ClassMethods
    def schema_columns=(columns)
      @@schema_columns = columns.reject{ |column| protected_columns.include?(column) }
    end
    
    def schema_columns
      @@schema_columns
    end
    
    def protected_columns
      %w( id )
    end
  end
  
  module InstanceMethods
    def initialize(*args)
      setup_schema
      super
    end
  
    private
  
    def setup_schema
      begin
        ActiveRecord::Migration.table_structure(self.class.table_name)
        update_schema
      rescue ActiveRecord::StatementInvalid => e
        if e.message.match(/Could not find table/)
          create_schema
        else
          raise e
        end
      end
    end
        
    def update_schema
      self.class.schema_columns.each do |column|
        ActiveRecord::Migration.add_column(self.class.table_name, column, :string) unless respond_to?(column.to_sym)
        (self.class.column_names - self.class.protected_columns).each do |column|
          ActiveRecord::Migration.remove_column(column) unless self.class.schema_columns.include?(column.to_s)
        end
      end
    end
  
    def create_schema
      ActiveRecord::Migration.create_table(self.class.table_name) do |t|;end;
      update_schema
    end
  end
end