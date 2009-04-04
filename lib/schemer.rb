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
      update_schema
      super
    end
  
    private
  
    def update_schema
      ActiveRecord::Migration.create_table(self.class.table_name) do |t|;end; unless self.class.table_exists?
      self.class.schema_columns.each do |column|
        ActiveRecord::Migration.add_column(self.class.table_name, column, :string) unless respond_to?(column.to_sym)
        (self.class.column_names - self.class.protected_columns).each do |column|
          ActiveRecord::Migration.remove_column(self.class.table_name, column) unless self.class.schema_columns.include?(column.to_s)
        end
      end
    end
  end
end
