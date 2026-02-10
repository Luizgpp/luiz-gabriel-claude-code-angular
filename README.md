# Luiz Gabriel Claude Code - Angular Plugin

A comprehensive Claude Code plugin with full Angular support (v12-15 and v16-20+), productivity commands, and specialized AI agents for modern web development.

## 🎯 Features

### 🅰️ **Angular Support**
- **7 Angular Commands** - Component, Service, Module, Guard, Directive, Pipe, Interceptor
- **2 Specialized Architects** - Angular 12-15 expert & Angular 16-20+ modern expert
- **Auto Version Detection** - Automatically detects your Angular version and applies appropriate patterns
- **Dual Version Support** - NgModules/RxJS for legacy, Standalone/Signals for modern

### ⚡ **Productivity Commands**
- `/new-task` - Analyze and plan implementation tasks
- `/code-explain` - Generate detailed code explanations
- `/code-optimize` - Optimize code for performance
- `/code-cleanup` - Clean up and refactor code
- `/feature-plan` - Plan new feature implementation
- `/lint` - Run linting and fix issues
- `/docs-generate` - Generate documentation

### 🔧 **Framework Commands**
- **React/Next.js**: `/component-new`, `/page-new`
- **API Development**: `/api-new`, `/api-test`, `/api-protect`
- **Supabase**: `/types-gen`, `/edge-function-new`
- **Angular**: See [Angular Support](#angular-commands) below

### 🤖 **13 Specialized AI Agents**
- Tech Stack Researcher
- Backend Architect
- Frontend Architect
- Performance Engineer
- Security Engineer
- System Architect
- Refactoring Expert
- Requirements Analyst
- Learning Guide
- Technical Writer
- Deep Research Agent

Plus **2 Angular Architects**:
- **angular-12-architect** - Expert for Angular 12-15 (NgModules, RxJS)
- **angular-modern-architect** - Expert for Angular 16-20+ (Signals, Standalone)

### 🔌 **MCP Servers**
- **context7** - Up-to-date documentation for any library
- **playwright** - Browser automation and testing
- **supabase** - Database operations and management

---

## 📦 Installation

### Method 1: Install from Local Path (Recommended)

```bash
# Install directly from local directory
/plugin install ~/Projects/luiz-gabriel-claude-code-angular
```

### Method 2: Create Symbolic Link

```bash
# Create a symbolic link in Claude plugins directory
ln -s ~/Projects/luiz-gabriel-claude-code-angular ~/.claude/plugins/luiz-gabriel-claude-code-angular

# Restart Claude Code
```

### Method 3: Copy to Plugins Directory

```bash
# Copy plugin to Claude directory
cp -r ~/Projects/luiz-gabriel-claude-code-angular ~/.claude/plugins/

# Verify installation
/plugin list
```

---

## 🅰️ Angular Commands

### Component Generation
```bash
/angular-component-new
```
Creates components with:
- Auto-detection of Angular version (12-15 vs 16-20+)
- Module-based or standalone patterns
- RxJS or Signals state management
- OnPush change detection
- Complete tests

### Service Generation
```bash
/angular-service-new
```
Creates services with:
- Dependency injection
- HTTP client integration
- State management (BehaviorSubject/Signals)
- Error handling
- Unit tests

### Module Generation
```bash
/angular-module-new
```
Creates modules with:
- Feature/Shared/Core patterns
- Routing configuration
- Lazy loading setup
- Barrel exports

### Guard Generation
```bash
/angular-guard-new
```
Creates route guards:
- CanActivate, CanDeactivate, CanLoad
- Class-based (12-15) or functional (16+)
- Authentication/authorization patterns

### Directive Generation
```bash
/angular-directive-new
```
Creates directives:
- Attribute and structural patterns
- Host listeners/bindings
- Safe DOM manipulation with Renderer2

### Pipe Generation
```bash
/angular-pipe-new
```
Creates pipes:
- Pure and impure patterns
- Data transformation logic
- Performance optimization

### Interceptor Generation
```bash
/angular-interceptor-new
```
Creates HTTP interceptors:
- Request/response handling
- Token injection
- Error handling and retry
- Loading state management

---

## 🚀 Usage Examples

### Generate Angular Components

```bash
# Launch Claude Code in your Angular project
cd your-angular-project

# Use Angular commands
/angular-component-new
# Provide: "Create a user profile component with reactive form"

/angular-service-new
# Provide: "Create authentication service with JWT token management"

/angular-guard-new
# Provide: "Create admin guard that checks user role"
```

### Get Expert Help

The Angular architects are automatically invoked based on your Angular version:

```bash
# For Angular 12-15 projects
"Refactor this component to use OnPush change detection"
# → angular-12-architect will help

# For Angular 16+ projects
"Convert this component to use signals instead of RxJS"
# → angular-modern-architect will help
```

### Use Productivity Commands

```bash
/code-optimize
# Analyze and optimize your Angular code

/docs-generate
# Generate documentation for your components

/lint
# Run linting and fix issues
```

---

## 📚 Angular Version Support

### Angular 12-15 (Legacy)
- **Module-based architecture** - Feature/Shared/Core modules
- **RxJS state management** - BehaviorSubject, Observables
- **Class-based guards/interceptors**
- **Traditional structural directives** - *ngIf, *ngFor
- **OnPush change detection**
- **Reactive forms**

### Angular 16-20+ (Modern)
- **Standalone components** - No NgModules required
- **Signal-based state** - signal(), computed(), effect()
- **Functional guards/interceptors**
- **Modern control flow** - @if, @for, @switch
- **Deferred loading** - @defer blocks
- **Signal inputs/outputs**
- **Typed reactive forms**

---

## 🔄 Update Plugin

To update the plugin with new changes:

```bash
cd ~/Projects/luiz-gabriel-claude-code-angular
git pull  # If using git

# Reload in Claude Code
/plugin reload luiz-gabriel-claude-code-angular
```

---

## 🛠️ Development

### Project Structure

```
luiz-gabriel-claude-code-angular/
├── .claude/
│   ├── agents/               # AI agents
│   │   ├── angular-12-architect.md
│   │   ├── angular-modern-architect.md
│   │   └── ... (11 other agents)
│   └── commands/             # Commands
│       ├── angular/          # Angular commands
│       │   ├── component-new.md
│       │   ├── service-new.md
│       │   ├── module-new.md
│       │   ├── guard-new.md
│       │   ├── directive-new.md
│       │   ├── pipe-new.md
│       │   └── interceptor-new.md
│       ├── api/              # API commands
│       ├── misc/             # Misc commands
│       ├── supabase/         # Supabase commands
│       └── ui/               # UI commands
├── .claude-plugin/
│   └── plugin.json           # Plugin configuration
├── ANGULAR_SUPPORT.md        # Angular documentation
├── README.md                 # This file
└── .gitignore
```

### Adding New Commands

1. Create a new `.md` file in the appropriate directory under `.claude/commands/`
2. Add the command entry to `.claude-plugin/plugin.json`
3. Commit and push changes (if using git)
4. Reload the plugin: `/plugin reload luiz-gabriel-claude-code-angular`

### Adding New Agents

1. Create a new `.md` file in `.claude/agents/`
2. Add the agent entry to `.claude-plugin/plugin.json`
3. Commit and push changes (if using git)
4. Reload the plugin: `/plugin reload luiz-gabriel-claude-code-angular`

---

## 📖 Documentation

- **[ANGULAR_SUPPORT.md](./ANGULAR_SUPPORT.md)** - Comprehensive Angular support documentation
- **[QUICK-START.md](./QUICK-START.md)** - Quick start guide
- **[PUBLISHING.md](./PUBLISHING.md)** - Publishing guide

---

## 🤝 Contributing

This is a personal plugin, but feel free to:
1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

MIT License - See LICENSE file for details

---

## 🙏 Credits

Created by Luiz Gabriel with comprehensive Angular support for both legacy (v12-15) and modern (v16-20+) versions.

---

## 📞 Support

If you encounter any issues or have questions:
1. Check the [ANGULAR_SUPPORT.md](./ANGULAR_SUPPORT.md) documentation
2. Review the command files in `.claude/commands/`
3. Open an issue in the repository

---

**Happy coding with Angular + Claude Code! 🎉**
