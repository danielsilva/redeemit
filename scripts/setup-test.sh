#!/bin/bash

# RedeemIt Test Environment Setup Script
# This script sets up the test environment for the RedeemIt application

set -e  # Exit on any error

echo "🧪 Setting up RedeemIt Test Environment"
echo "======================================="

# Check if Ruby 3.4.3 is installed
echo "📋 Checking Ruby version..."
if ! ruby --version | grep -q "3.4.3"; then
    echo "❌ Ruby 3.4.3 is not installed or not active"
    echo "Please install Ruby 3.4.3 using rbenv:"
    echo "  rbenv install 3.4.3"
    echo "  rbenv global 3.4.3"
    exit 1
fi
echo "✅ Ruby 3.4.3 is installed"

# Check if bundler is installed
echo "📋 Checking Bundler..."
if ! command -v bundle &> /dev/null; then
    echo "📦 Installing Bundler..."
    gem install bundler
fi
echo "✅ Bundler is available"

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

# Setup test database
echo "🗄️  Setting up test database..."
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate

# Check if Chrome/Chromium is available for acceptance tests
echo "📋 Checking browser for acceptance tests..."
if command -v google-chrome &> /dev/null || command -v chromium-browser &> /dev/null || command -v chromium &> /dev/null; then
    echo "✅ Chrome/Chromium is available for acceptance tests"
else
    echo "⚠️  Chrome/Chromium not found - acceptance tests may not work"
    echo "Please install Chrome or Chromium for full test suite"
fi

# Run database cleaner setup
echo "🧹 Setting up database cleaner..."
bundle exec rake db:test:prepare

# Run a quick test to verify setup
echo "🧪 Running a quick test to verify test environment..."
bundle exec rspec spec/integration/api/redemptions_controller/create_spec.rb --format progress

echo ""
echo "🎉 Test environment setup complete!"
echo "To run all tests:"
echo "bundle exec rspec"