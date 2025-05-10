namespace :deployment do
  desc "Enhanced deployment status check"
  task check: :environment do
    puts "Checking deployment..."
    puts "Ruby version: #{RUBY_VERSION}"
    puts "Rails version: #{Rails.version}"
    puts "Environment: #{Rails.env}"
    puts "Database: #{ActiveRecord::Base.connection.current_database}"
    puts "Migrations status: #{ActiveRecord::Base.connection.migration_context.needs_migration?}"
    puts "Redis connection: #{Sidekiq.redis_info ? 'OK' : 'Failed'}" rescue puts "Redis connection: N/A"
    puts "Dyno type: #{ENV['DYNO']}"
    puts "Web processes: #{ENV['WEB_CONCURRENCY'] || 'default'}"
    puts "Worker processes: #{ENV['SIDEKIQ_CONCURRENCY'] || 'default'}"
  end
end
