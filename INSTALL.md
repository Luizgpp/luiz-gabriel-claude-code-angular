# Installation Guide

## 🚀 Install from GitHub Repository

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `luiz-gabriel-claude-code-angular`
3. Description: "Claude Code plugin with comprehensive Angular support (v12 & v20+)"
4. Make it **Public** (so you can install it easily)
5. Click "Create repository"

### Step 2: Push to GitHub

```bash
cd ~/Projects/luiz-gabriel-claude-code-angular

# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/luiz-gabriel-claude-code-angular.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Install from GitHub

Now you can install it anywhere using Claude Code:

```bash
# Method 1: Direct GitHub install
/plugin install https://github.com/YOUR_USERNAME/luiz-gabriel-claude-code-angular

# Method 2: Add as marketplace and install
/plugin marketplace add YOUR_USERNAME/luiz-gabriel-claude-code-angular
/plugin install luiz-gabriel-claude-code-angular
```

---

## 💻 Install on Another Machine

### From GitHub (after Step 1-2 above)

```bash
# On any machine with Claude Code
/plugin install https://github.com/YOUR_USERNAME/luiz-gabriel-claude-code-angular
```

### From Local Clone

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/luiz-gabriel-claude-code-angular.git ~/Projects/luiz-gabriel-claude-code-angular

# Install locally
/plugin install ~/Projects/luiz-gabriel-claude-code-angular
```

---

## 🔄 Update Plugin

### Update from GitHub

```bash
cd ~/Projects/luiz-gabriel-claude-code-angular
git pull origin main

# Reload in Claude Code
/plugin reload luiz-gabriel-claude-code-angular
```

---

## ✅ Verify Installation

After installation, verify it works:

```bash
# List all plugins
/plugin list

# You should see: luiz-gabriel-claude-code-angular

# Test an Angular command
/angular-component-new
```

---

## 📦 Share with Your Team

Once on GitHub, share the install command:

```bash
# Anyone can install with:
/plugin install https://github.com/YOUR_USERNAME/luiz-gabriel-claude-code-angular
```

---

## 🛠️ Troubleshooting

### Plugin not showing up?

```bash
# Reload plugins
/plugin reload

# Or restart Claude Code
```

### Can't find commands?

```bash
# List all available commands
/help

# Look for angular- prefixed commands
```

### Want to uninstall?

```bash
/plugin uninstall luiz-gabriel-claude-code-angular
```

---

## 🌟 Pro Tips

1. **Keep it updated**: Push changes to GitHub and `git pull` on other machines
2. **Version control**: Use semantic versioning in `plugin.json`
3. **Share easily**: Anyone with the GitHub URL can install instantly
4. **Multiple machines**: Install on laptop, desktop, servers - all in sync
