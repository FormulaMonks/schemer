namespace :schemer do
  def migrations_for(glob, migrator)
    klasses = []
    
    Dir.glob(glob).each do |file|
      lineno  = 0
      result = File.readlines(file).each do |line|
        lineno += 1
        next unless line =~ /^class (.*) \<.*$/
        klasses << $1.constantize
      end
    end
    
    migration = klasses.collect do |klass|
      migrator.migration(klass)
    end.join("\n\n")
    
    puts "\nMigration from schema declarations in #{klasses.join(', ')}"
    puts "\n#{migration}\n\n"
  end
  
  namespace :rails do
    desc "Outputs a Rails migration from your schema declarations"
    task :migration => :environment do
      migrations_for File.join(Rails.root, "app", "models", "**.rb"), Schemer::ActiveRecord::Migrator
    end
  end
  
  namespace :activerecord do
    desc "Outputs an ActiveRecord migration from your schema declarations"
    task :migration do
      raise ArgumentError.new("Must provide path to your models on ENV[\"MODELS\"], i.e. rake schemer:activerecord:migration MODELS=./app/models/") unless ENV["MODELS"]
      
      migrations_for File.join(ENV["MODELS"], "**.rb"), Schemer::ActiveRecord::Migrator
    end
  end
  
  namespace :sequel do
    desc "Output a Sequel migration from your schema declarations"
    task :migration do
      raise ArgumentError.new("Must provide path to your models on ENV[\"MODELS\"], i.e. rake schemer:sequel:migration MODELS=./app/models/") unless ENV["MODELS"]
      
      migrations_for File.join(ENV["MODELS"], "**.rb"), Schemer::Sequel::Migrator
    end
  end
end
