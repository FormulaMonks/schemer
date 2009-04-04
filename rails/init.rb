raise "We highly suggest you only use Schemer in development mode!" unless Rails.env.to_s == 'development'
require 'schemer'
