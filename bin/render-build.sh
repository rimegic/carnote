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

# Test database connection first
echo "Testing database connection..."
bundle exec rails runner "puts 'Database connection test: ' + ActiveRecord::Base.connection.execute('SELECT version()').first['version']" || echo "Connection test failed"

echo "Attempting database migration..."
if bundle exec rake db:migrate --trace; then
  echo "Database migrations completed successfully!"
else
  echo "Migration failed with exit code $?"
  echo "Trying to create database first..."
  bundle exec rake db:create --trace || echo "Database creation failed or already exists"
  echo "Retrying migration..."
  bundle exec rake db:migrate --trace
fi

# Seed database if needed (optional, comment out if not needed)
echo "Seeding database..."
bundle exec rake db:seed || echo "Seeding failed or no seeds to run"

echo "Build completed successfully!"
