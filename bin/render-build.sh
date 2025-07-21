#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting build process..."

# Install dependencies
echo "Installing gems..."
bundle install

# Precompile assets
echo "Precompiling assets..."
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations (don't create, Render handles that)
echo "Running database migrations..."
bundle exec rake db:migrate

# Seed database if needed (optional, comment out if not needed)
echo "Seeding database..."
bundle exec rake db:seed || echo "Seeding failed or no seeds to run"

echo "Build completed successfully!"
