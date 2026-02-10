# Angular Support for luiz-gabriel-claude-code-angular

This plugin now includes comprehensive support for **Angular 12-15** and **Angular 16-20+** development.

## 🎯 Overview

The plugin has been enhanced with:
- **7 Angular-specific commands** for generating components, services, modules, guards, directives, pipes, and interceptors
- **2 specialized Angular architects** for version-specific best practices
- **Auto-detection** of Angular version from package.json
- **Dual-version support** for both legacy (12-15) and modern (16-20+) Angular patterns

---

## 📦 New Commands

### Component Generation
```bash
/angular-component-new
```
Creates Angular components with:
- Auto-detection of Angular version (12-15 vs 16-20+)
- Module-based (12-15) or standalone (16-20+) patterns
- RxJS (12-15) or Signals (16-20+) state management
- OnPush change detection
- Jasmine/Karma tests
- TypeScript strict typing

### Service Generation
```bash
/angular-service-new
```
Creates Angular services with:
- Dependency injection patterns
- HTTP client integration
- State management (BehaviorSubject or Signals)
- Error handling
- Unit tests

### Module Generation
```bash
/angular-module-new
```
Creates Angular modules with:
- Feature/Shared/Core module patterns
- Routing configuration
- Lazy loading setup
- Barrel exports (index.ts)

### Guard Generation
```bash
/angular-guard-new
```
Creates route guards with:
- CanActivate, CanDeactivate, CanLoad patterns
- Class-based (12-15) or functional (16+) guards
- Authentication/authorization logic
- TypeScript safety

### Directive Generation
```bash
/angular-directive-new
```
Creates directives with:
- Attribute and structural directive patterns
- Host listeners and bindings
- Renderer2 for safe DOM manipulation
- Unit tests

### Pipe Generation
```bash
/angular-pipe-new
```
Creates pipes with:
- Pure and impure pipe patterns
- Data transformation logic
- Performance optimization
- Unit tests

### Interceptor Generation
```bash
/angular-interceptor-new
```
Creates HTTP interceptors with:
- Request/response handling
- Authentication token injection
- Error handling and retry logic
- Loading state management
- Class-based (12-15) or functional (16+) interceptors

---

## 🤖 New Specialized Agents

### Angular 12-15 Architect
```bash
Use the angular-12-architect agent for legacy Angular projects
```

**Specializes in:**
- NgModule architecture (feature/shared/core modules)
- RxJS state management (BehaviorSubject, Observables)
- OnPush change detection strategies
- Reactive forms and template-driven forms
- Jasmine/Karma testing
- Subscription management (takeUntil pattern)
- Module-based lazy loading

**Best for:**
- Angular 12, 13, 14, 15 projects
- Existing codebases using NgModules
- Teams familiar with traditional Angular patterns

### Angular Modern (16-20+) Architect
```bash
Use the angular-modern-architect agent for modern Angular projects
```

**Specializes in:**
- Standalone components (no NgModules)
- Signal-based state management
- Modern control flow (@if, @for, @switch)
- Deferred loading (@defer)
- Functional guards and interceptors
- Signal inputs/outputs
- DestroyRef and takeUntilDestroyed
- Typed reactive forms

**Best for:**
- Angular 16, 17, 18, 19, 20+ projects
- New greenfield projects
- Teams adopting modern Angular patterns

---

## 🔄 Version Detection

All commands automatically detect your Angular version from `package.json` and apply appropriate patterns:

**Angular 12-15:**
- Module-based architecture
- RxJS for state management
- Class-based guards/interceptors
- Traditional structural directives (*ngIf, *ngFor)

**Angular 16-19:**
- Standalone components available
- Signals available
- Functional guards/interceptors
- Hybrid approach supported

**Angular 20+:**
- Standalone by default
- Signal-first approach
- Modern control flow (@if, @for)
- @defer for performance

---

## 💡 Usage Examples

### Create a new Angular component
```bash
/angular-component-new
# Provide specification: "Create a user profile component with form"
```

### Create a state management service
```bash
/angular-service-new
# Provide specification: "Create a user state service with authentication"
```

### Create a route guard
```bash
/angular-guard-new
# Provide specification: "Create an auth guard that checks if user is logged in"
```

### Use the Angular 12 architect for legacy project
```bash
# Ask: "Help me refactor this component using Angular 12 best practices"
# The angular-12-architect agent will be invoked automatically
```

### Use the Modern Angular architect for new project
```bash
# Ask: "Create a standalone component with signals"
# The angular-modern-architect agent will be invoked automatically
```

---

## 📚 Key Features

### Angular 12-15 Patterns
- **NgModules**: Feature, Shared, Core module organization
- **RxJS**: BehaviorSubject, Observables, operators (map, filter, switchMap)
- **Change Detection**: OnPush strategy with immutability
- **Forms**: Reactive forms with FormBuilder and FormGroup
- **Routing**: Module-based lazy loading
- **Testing**: Jasmine/Karma with TestBed

### Angular 16-20+ Patterns
- **Standalone**: Component-based architecture without modules
- **Signals**: signal(), computed(), effect() for reactive state
- **Control Flow**: @if, @for, @switch, @defer
- **Functional**: Functional guards, interceptors, resolvers
- **inject()**: Functional dependency injection
- **DestroyRef**: Automatic cleanup with takeUntilDestroyed()
- **Typed Forms**: Strongly typed FormControl and FormGroup

---

## 🎓 Best Practices

### Performance
- Use OnPush change detection
- Implement trackBy functions for *ngFor/@for
- Lazy load feature modules/routes
- Use @defer for heavy components (16+)

### State Management
- Angular 12-15: BehaviorSubject with immutable updates
- Angular 16+: Signals with computed() and effect()
- Keep state services simple and focused

### Testing
- Write unit tests for all components and services
- Use TestBed for component testing
- Mock HTTP calls with HttpClientTestingModule
- Test user interactions and edge cases

### Code Quality
- Enable TypeScript strict mode
- Use explicit types (no `any`)
- Keep components under 200 lines
- Follow single responsibility principle

---

## 🔧 Migration Support

The plugin supports migration paths:

**Angular 12 → 15:**
- Update dependencies gradually
- Adopt typed forms (Angular 14+)
- Consider standalone components (Angular 14+)

**Angular 15 → 16+:**
- Run standalone migration schematic
- Convert to functional guards/interceptors
- Introduce signals incrementally
- Adopt new control flow syntax (@if, @for)

**Angular 16+ → 20+:**
- Use @defer for performance
- Adopt signal inputs/outputs
- Leverage modern control flow
- Optimize with deferred loading

---

## 📝 Summary

The **luiz-gabriel-claude-code-angular** plugin now provides:

✅ **7 Angular commands** for code generation
✅ **2 specialized agents** for version-specific expertise
✅ **Auto-detection** of Angular version
✅ **Best practices** for both legacy and modern Angular
✅ **Performance optimization** patterns
✅ **Comprehensive testing** support
✅ **Migration guidance** between versions

Perfect for teams working with **Angular 12** (legacy) or **Angular 20+** (modern) projects!

---

## 🚀 Getting Started

1. Make sure the plugin is installed: `/plugin install luiz-gabriel-claude-code-angular`
2. Use Angular commands: `/angular-component-new`, `/angular-service-new`, etc.
3. Let the architects help: Ask Angular-specific questions and the appropriate agent will be invoked
4. Follow generated patterns for consistency across your project

Happy Angular coding! 🎉
