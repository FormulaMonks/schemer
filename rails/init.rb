raise "We highly suggest you only use Schemer in development or test mode (not in #{Rails.env})!" unless %w( development test ).include?(Rails.env.to_s)
Rails.logger.warn "Loading Schemer which will consider all your data volatile!"
require 'schemer'
