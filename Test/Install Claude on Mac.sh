#!/bin/bash
set -e

# Get project name from current folder
PROJECT_NAME=$(basename "$PWD")

echo "🔨 Building project..."
npm run build

# Install gh-pages package if not already installed
if [ ! -d "node_modules/gh-pages" ]; then
  echo "📦 Installing gh-pages..."
  npm install --save-dev gh-pages
fi

# Initialize git repo if needed
if [ ! -d ".git" ]; then
  echo "🔧 Initializing git repo..."
  git init
  git add .
  git commit -m "Initial commit"
fi

# Create GitHub repo if it doesn't exist remotely
if ! git remote get-url origin &> /dev/null; then
  echo "🌐 Creating GitHub repo: $PROJECT_NAME..."
  gh repo create "$PROJECT_NAME" --public --source=. --remote=origin --push
fi

# Deploy the dist folder to gh-pages branch
echo "🚀 Deploying to GitHub Pages..."
npx gh-pages -d dist

# Get the username and print the live link
USERNAME=$(gh api user --jq .login)
echo ""
echo "✅ Published!"
echo "🔗 Your live link: https://$USERNAME.github.io/$PROJECT_NAME/"
echo ""
echo "(It may take 1-2 minutes for GitHub Pages to go live the first time)"
