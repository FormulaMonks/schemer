Gem::Specification.new do |s|
  s.name     = 'schemer'
  s.version  = '0.0.9'
  s.summary  = %{On-the-fly ActiveRecord schema changes for extremely rapid prototyping.}
  s.date     = %q{2009-07-05}
  s.authors  = ["Ben Alavi"]
  s.email    = "ben.alavi@citrusbyte.com"
  s.homepage = "http://github.com/citrusbyte/schemer"
  s.files    = [
    		'README.markdown',
		'LICENSE',
		'Rakefile',
		'lib/schemer/migrator.rb',
		'lib/schemer.rb',
		'rails/init.rb',
		'test/schemer_test.rb',
		'tasks/schemer.rake'
  ]
end

