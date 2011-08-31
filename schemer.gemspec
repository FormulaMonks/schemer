require "./lib/schemer"

Gem::Specification.new do |s|
  s.name = "schemer"
  s.version = Schemer::VERSION
  s.summary = %{On-the-fly schema changes for extremely rapid prototyping.}
  s.date = %q{2011-08-30}
  s.authors = ["Ben Alavi"]
  s.email = "benalavi@gmail.com"
  s.homepage = "http://github.com/citrusbyte/schemer"
  
  s.files = Dir[
    "README.markdown",
		"Rakefile",
		"*.gemspec",
		"lib/**/*.rb",
		"lib/**/*.rake",
		"test/**/*.rb"
  ]
  
  s.add_development_dependency "contest"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sequel"
  s.add_development_dependency "active_record"
end
