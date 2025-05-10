namespace :deployment do
  desc "Check deployment status"
  task check: :environment do
    puts "Checking deployment..."
    puts "Ruby version: #{RUBY_VERSION}"
    puts "Rails version: #{Rails.version}"
    puts "Environment: #{Rails.env}"
    puts "Database: #{ActiveRecord::Base.connection.current_database}"
    puts "Migrations status:"
    puts ActiveRecord::Base.connection.migration_context.needs_migration?
  end
end
