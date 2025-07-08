#!/bin/bash

# RedeemIt Test Environment Setup Script
# This script sets up the test environment for the RedeemIt application

set -e  # Exit on any error

echo "🧪 Setting up RedeemIt Test Environment"
echo "======================================="

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

# Setup test database
echo "🗄️  Setting up test database..."
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate

# Check if Node.js is installed
echo "📋 Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org"
    exit 1
fi
echo "✅ Node.js is installed"

# Check if pnpm is installed
echo "📋 Checking pnpm..."
if ! command -v pnpm &> /dev/null; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi
echo "✅ pnpm is available"

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd client
pnpm install
cd ..

# Build frontend for production
echo "🔨 Building frontend for production..."
cd client
pnpm run build:production
cd ..

# Run database cleaner setup
echo "🧹 Setting up database cleaner..."
bundle exec rake db:test:prepare

# Run a quick test to verify setup
echo "🧪 Running a quick test to verify test environment..."
bundle exec rspec spec/integration/api/redemptions_controller/create_spec.rb --format progress

echo ""
echo "🎉 Test environment setup complete!"
echo ""
echo "To run all tests run: bundle exec rspec"
