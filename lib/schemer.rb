module Schemer
  def schema(*args)
    extend  ClassMethods
    include InstanceMethods
    
    class_inheritable_accessor :schema_columns
    self.schema_columns = args.collect(&:to_s)
  end

  module ClassMethods
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
          ActiveRecord::Migration.remove_column(self.class.table_name, column) unless self.class.schema_columns.include?(column.to_s)
        end
      end
    end
  
    def create_schema
      ActiveRecord::Migration.create_table(self.class.table_name) do |t|;end;
      update_schema
    end
  end
end
