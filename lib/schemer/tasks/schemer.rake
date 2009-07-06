namespace :schemer do
  desc "Outputs the basis of a Rails migration from your schema declarations"
  task :migration => :environment do
    klasses = []

    Dir.glob(File.join(Rails.root, "app", "models", "**.rb")).each do |file|
      lineno  = 0
      result = File.readlines(file).each do |line|
        lineno += 1
        next unless line =~ /^class (.*) \<.*$/
        klasses << $1.constantize
      end
    end
    
    migration = klasses.collect do |klass|
      Schemer::Migrator.migration(klass)
    end.join("\n\n")
    
    puts "\nMigration from schema declarations in #{klasses.join(', ')}"
    puts "\n#{migration}\n\n"
  end
end
