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

# Wait for database to be ready and test connection
echo "Waiting for database to be ready..."
for i in {1..30}; do
  if bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" 2>/dev/null; then
    echo "Database connection successful!"
    break
  else
    echo "Attempt $i: Database not ready, waiting 5 seconds..."
    sleep 5
  fi
  
  if [ $i -eq 30 ]; then
    echo "Database connection failed after 30 attempts"
    echo "DATABASE_URL: $DATABASE_URL"
    exit 1
  fi
done

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate

# Seed database if needed (optional, comment out if not needed)
echo "Seeding database..."
bundle exec rake db:seed || echo "Seeding failed or no seeds to run"

echo "Build completed successfully!"
