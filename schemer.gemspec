Gem::Specification.new do |s|
  s.name = 'schemer'
  s.version = '0.0.3'
  s.summary = %{On-the-fly ActiveRecord schema changes for extremely rapid prototyping.}
  s.date = %q{2009-04-03}
  s.authors = ["Ben Alavi"]
  s.email = "ben.alavi@citrusbyte.com"
  s.homepage = "http://github.com/citrusbyte/schemer"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/schemer.rb", "README.markdown", "LICENSE", "Rakefile", "rails/init.rb", "test/schemer_test.rb"]

  s.require_paths = ['lib']

  s.has_rdoc = false
end

