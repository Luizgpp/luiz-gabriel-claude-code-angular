---
description: Create a new Angular module with routing and best practices
model: claude-sonnet-4-5
---

Generate a new Angular module following Angular best practices.

## Module Specification

$ARGUMENTS

## Angular Module Patterns

### 1. **Feature Module (Angular 12-15)**

```typescript
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FeatureRoutingModule } from './feature-routing.module';
import { FeatureComponent } from './feature.component';
import { SharedModule } from '@shared/shared.module';

@NgModule({
  declarations: [
    FeatureComponent,
    // Other components
  ],
  imports: [
    CommonModule,
    FeatureRoutingModule,
    SharedModule
  ],
  providers: [
    // Feature-specific services
  ]
})
export class FeatureModule { }
```

### 2. **Routing Module (Angular 12-15)**

```typescript
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FeatureComponent } from './feature.component';

const routes: Routes = [
  {
    path: '',
    component: FeatureComponent,
    children: [
      // Child routes
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FeatureRoutingModule { }
```

### 3. **Shared Module (Angular 12-15)**

```typescript
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

// Shared components
import { ButtonComponent } from './components/button/button.component';
import { CardComponent } from './components/card/card.component';

// Shared directives
import { HighlightDirective } from './directives/highlight.directive';

// Shared pipes
import { TruncatePipe } from './pipes/truncate.pipe';

const COMPONENTS = [ButtonComponent, CardComponent];
const DIRECTIVES = [HighlightDirective];
const PIPES = [TruncatePipe];

@NgModule({
  declarations: [
    ...COMPONENTS,
    ...DIRECTIVES,
    ...PIPES
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    // Re-export common modules
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    // Export shared components/directives/pipes
    ...COMPONENTS,
    ...DIRECTIVES,
    ...PIPES
  ]
})
export class SharedModule { }
```

### 4. **Core Module (Angular 12-15)**

```typescript
import { NgModule, Optional, SkipSelf } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';

// Services
import { AuthService } from './services/auth.service';
import { ApiService } from './services/api.service';

// Interceptors
import { AuthInterceptor } from './interceptors/auth.interceptor';
import { ErrorInterceptor } from './interceptors/error.interceptor';

// Guards
import { AuthGuard } from './guards/auth.guard';

@NgModule({
  imports: [
    CommonModule,
    HttpClientModule
  ],
  providers: [
    // Services
    AuthService,
    ApiService,
    // Guards
    AuthGuard,
    // Interceptors
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ErrorInterceptor,
      multi: true
    }
  ]
})
export class CoreModule {
  // Prevent reimport of CoreModule
  constructor(@Optional() @SkipSelf() parentModule: CoreModule) {
    if (parentModule) {
      throw new Error('CoreModule is already loaded. Import it in AppModule only.');
    }
  }
}
```

### 5. **Standalone Routes (Angular 16+)**

**Note**: In Angular 16+, prefer standalone components over NgModules

```typescript
// feature.routes.ts
import { Routes } from '@angular/router';

export const FEATURE_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./feature.component').then(m => m.FeatureComponent),
    children: [
      {
        path: 'detail/:id',
        loadComponent: () => import('./detail.component').then(m => m.DetailComponent)
      }
    ]
  }
];
```

**App Routes (Angular 16+)**
```typescript
// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'home',
    pathMatch: 'full'
  },
  {
    path: 'home',
    loadComponent: () => import('./home/home.component').then(m => m.HomeComponent)
  },
  {
    path: 'feature',
    loadChildren: () => import('./feature/feature.routes').then(m => m.FEATURE_ROUTES)
  },
  {
    path: '**',
    redirectTo: 'home'
  }
];
```

### 6. **Lazy Loading**

**Module-based (Angular 12-15)**
```typescript
const routes: Routes = [
  {
    path: 'admin',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule),
    canActivate: [AuthGuard]
  }
];
```

**Standalone-based (Angular 16+)**
```typescript
const routes: Routes = [
  {
    path: 'admin',
    loadChildren: () => import('./admin/admin.routes').then(m => m.ADMIN_ROUTES),
    canActivate: [AuthGuard]
  }
];
```

## Module Types

### Feature Module
- Domain-specific features
- Lazy-loadable
- Self-contained functionality
- Own routing module

### Shared Module
- Reusable components/directives/pipes
- Imported by multiple feature modules
- No singleton services
- Export common dependencies

### Core Module
- App-wide singleton services
- Interceptors and guards
- Imported once in AppModule
- Prevent reimport pattern

## Module Organization

```
src/app/
├── core/                   # Singleton services
│   ├── services/
│   ├── interceptors/
│   ├── guards/
│   └── core.module.ts
├── shared/                 # Shared components
│   ├── components/
│   ├── directives/
│   ├── pipes/
│   └── shared.module.ts
├── features/               # Feature modules
│   ├── feature-a/
│   │   ├── feature-a.module.ts
│   │   ├── feature-a-routing.module.ts
│   │   └── components/
│   └── feature-b/
└── app.module.ts
```

## Migration to Standalone (Angular 16+)

**When to use NgModules:**
- Angular 12-15 projects
- Large existing codebases
- Team preference

**When to use Standalone:**
- Angular 16+ new projects
- Simpler dependency management
- Better tree-shaking
- Recommended for new development

## Best Practices

1. **One Module Per Feature**: Keep features isolated
2. **Lazy Load Features**: Improve initial load time
3. **Shared Module Pattern**: DRY principle for common code
4. **Core Module Singleton**: Prevent duplicate services
5. **Routing Module Separation**: Clean route definitions
6. **Barrel Exports**: Use index.ts for public API
7. **Strict Typing**: Type all route data and params

## What to Generate

1. **Feature Module File** - NgModule with declarations/imports
2. **Routing Module File** - Route definitions
3. **Module Barrel Export** - index.ts for public API
4. **Folder Structure** - Organized feature directory

Generate well-structured Angular modules with proper lazy loading and separation of concerns.
