$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "fileutils"
require "contest"
require "logger"

# active_record 3.0.10
# libsqlite3-dev + sqlite3 1.3.4

begin
  require "ruby-debug"
rescue LoadError
end

OUTPUT = File.join(File.dirname(__FILE__), "out")
FileUtils.mkdir_p(OUTPUT)
