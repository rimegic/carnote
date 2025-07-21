#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting build process..."

# Check environment variables
echo "Checking environment variables..."
echo "RAILS_ENV: $RAILS_ENV"
echo "DATABASE_URL exists: $([ -n "$DATABASE_URL" ] && echo "Yes" || echo "No")"
echo "RAILS_MASTER_KEY exists: $([ -n "$RAILS_MASTER_KEY" ] && echo "Yes" || echo "No")"

# Install dependencies
echo "Installing gems..."
bundle install

# Precompile assets
echo "Precompiling assets..."
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Check database connection
echo "Checking database connection..."
echo "DATABASE_URL exists: $([ -n "$DATABASE_URL" ] && echo "Yes" || echo "No")"
echo "DATABASE_URL length: ${#DATABASE_URL}"
if [ -n "$DATABASE_URL" ]; then
  echo "DATABASE_URL (first 50 chars): ${DATABASE_URL:0:50}..."
else
  echo "ERROR: DATABASE_URL is not set!"
  echo "Available environment variables:"
  env | grep -E "(DATABASE|POSTGRES|PG)" || echo "No database-related env vars found"
  exit 1
fi

# Try a simpler approach - just run migrations directly
echo "Attempting to run migrations directly..."

# Run database migrations with error handling
echo "Running database migrations..."
echo "Current working directory: $(pwd)"
echo "Rails environment: $RAILS_ENV"

# Generate Solid Queue migrations
echo "Generating Solid Queue migrations..."
bundle exec rails generate solid_queue:install || echo "Solid Queue generator failed or already done"

# Generate Solid Cache migrations  
echo "Generating Solid Cache migrations..."
bundle exec rails generate solid_cache:install || echo "Solid Cache generator failed or already done"

# Generate Solid Cable migrations
echo "Generating Solid Cable migrations..."
bundle exec rails generate solid_cable:install || echo "Solid Cable generator failed or already done"

# List migration files to verify they exist
echo "Checking migration files..."
ls -la db/migrate/ | grep -E "(solid_queue|solid_cache|solid_cable)" || echo "No solid migrations found"

# Remove schema.rb to force regeneration from migrations
echo "Removing existing schema.rb to force regeneration..."
rm -f db/schema.rb

# Test database connection first
echo "Testing database connection..."
bundle exec rails runner "puts 'Database connection test: ' + ActiveRecord::Base.connection.execute('SELECT version()').first['version']" || echo "Connection test failed"

echo "Attempting database migration..."
echo "Running migrations with verbose output..."
if VERBOSE=true bundle exec rake db:migrate --trace 2>&1; then
  echo "Database migrations completed successfully!"
else
  echo "Migration failed with exit code $?"
  echo "Checking database status..."
  bundle exec rake db:version || echo "Could not get database version"
  echo "Listing existing tables..."
  bundle exec rails runner "puts ActiveRecord::Base.connection.tables" || echo "Could not list tables"
  echo "Trying to create database first..."
  bundle exec rake db:create --trace || echo "Database creation failed or already exists"
  echo "Retrying migration with verbose output..."
  VERBOSE=true bundle exec rake db:migrate --trace 2>&1
fi

# Seed database if needed (optional, comment out if not needed)
echo "Seeding database..."
bundle exec rake db:seed || echo "Seeding failed or no seeds to run"

echo "Build completed successfully!"
