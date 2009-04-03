require 'schemer'
raise "We would highly suggest you only use Schemer in development mode!" unless Rails.env.to_s == 'development'
ActiveRecord::Base.extend(Schemer)