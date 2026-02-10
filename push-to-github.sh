#!/bin/bash

echo "🚀 Push to GitHub Setup"
echo ""
echo "Please enter your GitHub username:"
read GITHUB_USERNAME

echo ""
echo "Setting up remote repository..."
cd ~/Projects/luiz-gabriel-claude-code-angular

# Add remote
git remote add origin https://github.com/$GITHUB_USERNAME/luiz-gabriel-claude-code-angular.git

# Push to GitHub
git branch -M main
git push -u origin main

echo ""
echo "✅ Done! Your plugin is now on GitHub"
echo ""
echo "📦 Install it anywhere with:"
echo "/plugin install https://github.com/$GITHUB_USERNAME/luiz-gabriel-claude-code-angular"
echo ""
echo "Or add to marketplace:"
echo "/plugin marketplace add $GITHUB_USERNAME/luiz-gabriel-claude-code-angular"
echo "/plugin install luiz-gabriel-claude-code-angular"
