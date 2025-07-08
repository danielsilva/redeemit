#!/bin/bash

# RedeemIt Development Environment Setup Script
# This script sets up the development environment for the RedeemIt application

set -e  # Exit on any error

echo "🚀 Setting up RedeemIt Development Environment"
echo "=============================================="

# Initialize rbenv
eval "$(rbenv init -)"

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

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

# Check if overmind is installed
echo "📋 Checking overmind..."
if ! command -v overmind &> /dev/null; then
    echo "📦 Installing overmind..."
    if command -v brew &> /dev/null; then
        brew install overmind
    else
        echo "❌ Homebrew not found. Please install overmind manually:"
        echo "  brew install overmind"
        echo "  # OR download from: https://github.com/DarthSim/overmind"
        exit 1
    fi
fi
echo "✅ overmind is available"

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd client
pnpm install
cd ..

# Setup database
echo "🗄️  Setting up development database..."
rails db:create
rails db:migrate
rails db:seed

# Run initial tests to ensure everything is working
echo "🧪 Running a quick test to verify setup..."
bundle exec rspec spec/integration/api/redemptions_controller/create_spec.rb --format progress

echo ""
echo "🎉 Development environment setup complete!"
echo ""
echo "To start the application run: ./scripts/start-dev.sh"