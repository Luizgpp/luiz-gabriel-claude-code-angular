---
description: Create a new Angular HTTP interceptor for request/response handling
model: claude-sonnet-4-5
---

Generate a new Angular HTTP interceptor following Angular best practices.

## Interceptor Specification

$ARGUMENTS

## Angular Interceptor Patterns

### 1. **Auth Interceptor (Angular 12-15)**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from '../services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authService: AuthService) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const token = this.authService.getToken();

    if (token) {
      const cloned = req.clone({
        headers: req.headers.set('Authorization', `Bearer ${token}`)
      });
      return next.handle(cloned);
    }

    return next.handle(req);
  }
}
```

### 2. **Functional Interceptor (Angular 16+)**

```typescript
import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const token = authService.getToken();

  if (token) {
    const cloned = req.clone({
      headers: req.headers.set('Authorization', `Bearer ${token}`)
    });
    return next(cloned);
  }

  return next(req);
};
```

### 3. **Error Handling Interceptor**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import { Router } from '@angular/router';

@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  constructor(private router: Router) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return next.handle(req).pipe(
      retry(1), // Retry once on failure
      catchError((error: HttpErrorResponse) => {
        let errorMessage = 'An error occurred';

        if (error.error instanceof ErrorEvent) {
          // Client-side error
          errorMessage = `Error: ${error.error.message}`;
        } else {
          // Server-side error
          switch (error.status) {
            case 401:
              errorMessage = 'Unauthorized - Please log in';
              this.router.navigate(['/login']);
              break;
            case 403:
              errorMessage = 'Forbidden - Access denied';
              break;
            case 404:
              errorMessage = 'Not found';
              break;
            case 500:
              errorMessage = 'Internal server error';
              break;
            default:
              errorMessage = `Error ${error.status}: ${error.message}`;
          }
        }

        console.error(errorMessage);
        return throwError(() => new Error(errorMessage));
      })
    );
  }
}
```

### 4. **Loading Interceptor**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { LoadingService } from '../services/loading.service';

@Injectable()
export class LoadingInterceptor implements HttpInterceptor {
  private activeRequests = 0;

  constructor(private loadingService: LoadingService) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if (this.activeRequests === 0) {
      this.loadingService.show();
    }

    this.activeRequests++;

    return next.handle(req).pipe(
      finalize(() => {
        this.activeRequests--;
        if (this.activeRequests === 0) {
          this.loadingService.hide();
        }
      })
    );
  }
}
```

### 5. **Caching Interceptor**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpResponse } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class CacheInterceptor implements HttpInterceptor {
  private cache = new Map<string, HttpResponse<any>>();
  private cacheExpiry = 5 * 60 * 1000; // 5 minutes

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // Only cache GET requests
    if (req.method !== 'GET') {
      return next.handle(req);
    }

    // Check if response is in cache
    const cachedResponse = this.cache.get(req.url);
    if (cachedResponse) {
      return of(cachedResponse.clone());
    }

    // If not cached, make request and cache response
    return next.handle(req).pipe(
      tap(event => {
        if (event instanceof HttpResponse) {
          this.cache.set(req.url, event.clone());

          // Clear cache after expiry
          setTimeout(() => {
            this.cache.delete(req.url);
          }, this.cacheExpiry);
        }
      })
    );
  }
}
```

### 6. **Logging Interceptor**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpResponse } from '@angular/common/http';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const started = Date.now();
    console.log(`[HTTP] ${req.method} ${req.url}`);

    return next.handle(req).pipe(
      tap({
        next: (event) => {
          if (event instanceof HttpResponse) {
            const elapsed = Date.now() - started;
            console.log(`[HTTP] ${req.method} ${req.url} completed in ${elapsed}ms`, {
              status: event.status,
              body: event.body
            });
          }
        },
        error: (error) => {
          const elapsed = Date.now() - started;
          console.error(`[HTTP] ${req.method} ${req.url} failed after ${elapsed}ms`, error);
        }
      })
    );
  }
}
```

### 7. **Retry with Exponential Backoff**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable, throwError, timer } from 'rxjs';
import { mergeMap, retry } from 'rxjs/operators';

@Injectable()
export class RetryInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return next.handle(req).pipe(
      retry({
        count: 3,
        delay: (error, retryCount) => {
          // Exponential backoff: 1s, 2s, 4s
          const delayMs = Math.pow(2, retryCount - 1) * 1000;

          // Only retry on specific status codes
          if (error.status >= 500 || error.status === 0) {
            console.log(`Retrying request (attempt ${retryCount}) after ${delayMs}ms`);
            return timer(delayMs);
          }

          return throwError(() => error);
        }
      })
    );
  }
}
```

### 8. **Request/Response Transformation**

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpResponse } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

interface ApiResponse<T> {
  data: T;
  status: string;
  message?: string;
}

@Injectable()
export class ApiInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // Transform request (e.g., add API prefix)
    const apiReq = req.clone({
      url: `${environment.apiUrl}${req.url}`,
      setHeaders: {
        'Content-Type': 'application/json',
        'X-API-Version': '1.0'
      }
    });

    return next.handle(apiReq).pipe(
      map(event => {
        // Transform response
        if (event instanceof HttpResponse) {
          const body = event.body as ApiResponse<any>;
          if (body?.data) {
            return event.clone({ body: body.data });
          }
        }
        return event;
      })
    );
  }
}
```

## Interceptor Registration

### Angular 12-15 (Class-based)

```typescript
// app.module.ts
import { HTTP_INTERCEPTORS } from '@angular/common/http';

@NgModule({
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ErrorInterceptor,
      multi: true
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: LoadingInterceptor,
      multi: true
    }
  ]
})
export class AppModule {}
```

### Angular 16+ (Functional)

```typescript
// app.config.ts
import { provideHttpClient, withInterceptors } from '@angular/common/http';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(
      withInterceptors([
        authInterceptor,
        errorInterceptor,
        loadingInterceptor
      ])
    )
  ]
};
```

## Interceptor Order

Interceptors execute in the order they are provided:
1. Request flows DOWN (first to last)
2. Response flows UP (last to first)

```
Request  →  Auth  →  Logging  →  API  →  Server
Response ←  Auth  ←  Logging  ←  API  ←  Server
```

## Best Practices

1. **Order Matters**: Register interceptors in logical order
2. **Immutability**: Always clone requests, never modify originals
3. **Error Handling**: Always handle errors appropriately
4. **Selective Application**: Check request properties before applying logic
5. **Performance**: Be mindful of performance impact
6. **Testing**: Mock interceptors in tests
7. **Conditional Logic**: Skip interceptor logic when not needed

## Common Use Cases

**Authentication**
- Add JWT tokens
- Refresh expired tokens
- Handle 401 responses

**Error Handling**
- Catch and transform errors
- Retry failed requests
- Show user-friendly messages

**Loading States**
- Track active requests
- Show/hide loading spinner
- Handle concurrent requests

**Caching**
- Cache GET requests
- Invalidate on mutations
- Configure TTL

**Logging**
- Request/response logging
- Performance monitoring
- Error tracking

## Testing Interceptors

```typescript
import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { HTTP_INTERCEPTORS, HttpClient } from '@angular/common/http';
import { AuthInterceptor } from './auth.interceptor';
import { AuthService } from '../services/auth.service';

describe('AuthInterceptor', () => {
  let httpMock: HttpTestingController;
  let httpClient: HttpClient;
  let authService: jasmine.SpyObj<AuthService>;

  beforeEach(() => {
    const authSpy = jasmine.createSpyObj('AuthService', ['getToken']);

    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [
        {
          provide: HTTP_INTERCEPTORS,
          useClass: AuthInterceptor,
          multi: true
        },
        { provide: AuthService, useValue: authSpy }
      ]
    });

    httpMock = TestBed.inject(HttpTestingController);
    httpClient = TestBed.inject(HttpClient);
    authService = TestBed.inject(AuthService) as jasmine.SpyObj<AuthService>;
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should add Authorization header when token exists', () => {
    authService.getToken.and.returnValue('test-token');

    httpClient.get('/api/data').subscribe();

    const req = httpMock.expectOne('/api/data');
    expect(req.request.headers.has('Authorization')).toBe(true);
    expect(req.request.headers.get('Authorization')).toBe('Bearer test-token');
  });
});
```

## What to Generate

1. **Interceptor TypeScript File** - Interceptor class or function
2. **Interceptor Spec File** - Unit tests
3. **Provider Configuration** - How to register
4. **Service Dependencies** - Required services

Generate production-ready Angular HTTP interceptors with proper error handling, testing, and performance optimization.
