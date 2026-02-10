---
description: Create a new Angular route guard with authentication and authorization
model: claude-sonnet-4-5
---

Generate a new Angular route guard following Angular best practices.

## Guard Specification

$ARGUMENTS

## Angular Guard Patterns

### 1. **CanActivate Guard (Angular 12-15)**

```typescript
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router, UrlTree } from '@angular/router';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    return this.authService.isAuthenticated$.pipe(
      map(isAuth => {
        if (isAuth) {
          return true;
        }
        return this.router.createUrlTree(['/login'], {
          queryParams: { returnUrl: state.url }
        });
      })
    );
  }
}
```

### 2. **Functional Guard (Angular 16+)**

```typescript
import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  return authService.isAuthenticated$.pipe(
    map(isAuth => {
      if (isAuth) {
        return true;
      }
      return router.createUrlTree(['/login'], {
        queryParams: { returnUrl: state.url }
      });
    })
  );
};
```

### 3. **Role-Based Authorization Guard**

**Angular 12-15**
```typescript
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class RoleGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(route: ActivatedRouteSnapshot): Observable<boolean> {
    const requiredRoles = route.data['roles'] as string[];

    return this.authService.userRoles$.pipe(
      map(userRoles => {
        const hasRole = requiredRoles.some(role => userRoles.includes(role));
        if (!hasRole) {
          this.router.navigate(['/unauthorized']);
          return false;
        }
        return true;
      })
    );
  }
}
```

**Angular 16+ Functional**
```typescript
import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

export const roleGuard: CanActivateFn = (route) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const requiredRoles = route.data['roles'] as string[];

  return authService.userRoles$.pipe(
    map(userRoles => {
      const hasRole = requiredRoles.some(role => userRoles.includes(role));
      if (!hasRole) {
        router.navigate(['/unauthorized']);
        return false;
      }
      return true;
    })
  );
};
```

### 4. **CanDeactivate Guard (Unsaved Changes)**

```typescript
import { Injectable } from '@angular/core';
import { CanDeactivate } from '@angular/router';
import { Observable } from 'rxjs';

export interface CanComponentDeactivate {
  canDeactivate: () => Observable<boolean> | Promise<boolean> | boolean;
}

@Injectable({
  providedIn: 'root'
})
export class UnsavedChangesGuard implements CanDeactivate<CanComponentDeactivate> {
  canDeactivate(
    component: CanComponentDeactivate
  ): Observable<boolean> | Promise<boolean> | boolean {
    return component.canDeactivate ? component.canDeactivate() : true;
  }
}

// Component implementation
export class EditComponent implements CanComponentDeactivate {
  hasUnsavedChanges = false;

  canDeactivate(): boolean {
    if (this.hasUnsavedChanges) {
      return confirm('You have unsaved changes. Do you really want to leave?');
    }
    return true;
  }
}
```

### 5. **CanLoad Guard (Lazy Loading)**

```typescript
import { Injectable } from '@angular/core';
import { CanLoad, Route, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AdminLoadGuard implements CanLoad {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canLoad(route: Route): Observable<boolean> {
    return this.authService.hasAdminRole$.pipe(
      map(isAdmin => {
        if (!isAdmin) {
          this.router.navigate(['/unauthorized']);
          return false;
        }
        return true;
      })
    );
  }
}
```

### 6. **CanMatch Guard (Angular 16+)**

```typescript
import { inject } from '@angular/core';
import { CanMatchFn, Router } from '@angular/router';
import { map } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';

export const adminMatchGuard: CanMatchFn = (route, segments) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  return authService.hasAdminRole$.pipe(
    map(isAdmin => {
      if (!isAdmin) {
        router.navigate(['/unauthorized']);
        return false;
      }
      return true;
    })
  );
};
```

## Guard Types

### CanActivate
- Prevents route activation
- Authentication checks
- Authorization checks
- Feature flags

### CanActivateChild
- Protects child routes
- Parent-level checks
- Inherited permissions

### CanDeactivate
- Confirms leaving route
- Unsaved changes warnings
- Data validation

### CanLoad
- Prevents lazy module loading
- Performance optimization
- Conditional feature loading

### CanMatch (Angular 16+)
- Route matching logic
- Dynamic route selection
- Version-based routing

## Route Configuration

**Angular 12-15**
```typescript
const routes: Routes = [
  {
    path: 'admin',
    component: AdminComponent,
    canActivate: [AuthGuard, RoleGuard],
    canActivateChild: [RoleGuard],
    canDeactivate: [UnsavedChangesGuard],
    data: { roles: ['admin'] }
  },
  {
    path: 'settings',
    loadChildren: () => import('./settings/settings.module').then(m => m.SettingsModule),
    canLoad: [AdminLoadGuard]
  }
];
```

**Angular 16+ Functional**
```typescript
const routes: Routes = [
  {
    path: 'admin',
    component: AdminComponent,
    canActivate: [authGuard, roleGuard],
    canMatch: [adminMatchGuard],
    data: { roles: ['admin'] }
  }
];
```

## Best Practices

1. **Return UrlTree**: Use `router.createUrlTree()` instead of `router.navigate()`
2. **Composition**: Combine multiple guards with arrays
3. **Error Handling**: Handle authentication failures gracefully
4. **Performance**: Use CanMatch to prevent loading unnecessary code
5. **Testing**: Unit test guard logic separately from routing
6. **Type Safety**: Use proper return types (boolean | UrlTree)

## Testing Guards

```typescript
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { AuthGuard } from './auth.guard';
import { AuthService } from '../services/auth.service';
import { of } from 'rxjs';

describe('AuthGuard', () => {
  let guard: AuthGuard;
  let authService: jasmine.SpyObj<AuthService>;
  let router: jasmine.SpyObj<Router>;

  beforeEach(() => {
    const authSpy = jasmine.createSpyObj('AuthService', [], {
      isAuthenticated$: of(true)
    });
    const routerSpy = jasmine.createSpyObj('Router', ['createUrlTree']);

    TestBed.configureTestingModule({
      providers: [
        AuthGuard,
        { provide: AuthService, useValue: authSpy },
        { provide: Router, useValue: routerSpy }
      ]
    });

    guard = TestBed.inject(AuthGuard);
    authService = TestBed.inject(AuthService) as jasmine.SpyObj<AuthService>;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
  });

  it('should allow activation when authenticated', (done) => {
    guard.canActivate(null as any, null as any).subscribe(result => {
      expect(result).toBe(true);
      done();
    });
  });
});
```

## What to Generate

1. **Guard TypeScript File** - Guard class or function
2. **Guard Spec File** - Unit tests
3. **Route Configuration Example** - How to use the guard
4. **Service Dependencies** - Required services (AuthService, etc.)

Generate secure, type-safe Angular route guards with proper error handling and testing.
