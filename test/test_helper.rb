$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "fileutils"
require "contest"
require "logger"

begin
  require "ruby-debug"
rescue LoadError
end

OUTPUT = File.join(File.dirname(__FILE__), "out")
FileUtils.mkdir_p(OUTPUT)
