#!/bin/bash

# VSM Starter Setup Script
# This script initializes the VSM Starter repository

echo "🚀 VSM Starter Setup"
echo "===================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: VSM Starter template"
fi

# Install dependencies
echo "📥 Installing dependencies..."
mix deps.get

# Compile the project
echo "🔨 Compiling project..."
mix compile

# Run tests
echo "🧪 Running tests..."
mix test

# Run quality checks
echo "✨ Running quality checks..."
mix format
mix credo --strict || true
mix dialyzer || true

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Create a GitHub repository: https://github.com/new"
echo "2. Add the remote: git remote add origin https://github.com/viable-systems/vsm-starter.git"
echo "3. Push to GitHub: git push -u origin main"
echo "4. Publish to Hex: mix hex.publish"
echo ""
echo "To use this template in a new project:"
echo "  mix new my_vsm_app --sup"
echo "  cd my_vsm_app"
echo "  # Add {:vsm_starter, \"~> 0.1.0\"} to deps in mix.exs"
echo "  mix deps.get"
echo ""
echo "Happy coding with VSM! 🎉"