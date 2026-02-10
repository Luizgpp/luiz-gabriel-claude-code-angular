---
description: Create a new Angular service with dependency injection and best practices
model: claude-sonnet-4-5
---

Generate a new Angular service following Angular best practices.

## Service Specification

$ARGUMENTS

## Angular Service Patterns

### 1. **Basic Service Structure**

**Angular 12-15**
```typescript
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root' // Singleton service
})
export class DataService {
  constructor() { }
}
```

**Angular 20+**
```typescript
import { Injectable, signal } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private dataSignal = signal<DataType[]>([]);
  readonly data = this.dataSignal.asReadonly();

  updateData(newData: DataType[]): void {
    this.dataSignal.set(newData);
  }
}
```

### 2. **HTTP Service Pattern**

**Angular 12-15 (RxJS)**
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { map, catchError, tap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'https://api.example.com';
  private dataSubject = new BehaviorSubject<DataType[]>([]);
  data$ = this.dataSubject.asObservable();

  constructor(private http: HttpClient) {}

  getData(): Observable<DataType[]> {
    return this.http.get<DataType[]>(`${this.apiUrl}/data`).pipe(
      tap(data => this.dataSubject.next(data)),
      catchError(this.handleError)
    );
  }

  private handleError(error: any): Observable<never> {
    console.error('API Error:', error);
    throw error;
  }
}
```

**Angular 20+ (Signals + RxJS)**
```typescript
import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { toSignal } from '@angular/core/rxjs-interop';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'https://api.example.com';
  private dataSignal = signal<DataType[]>([]);
  readonly data = this.dataSignal.asReadonly();

  constructor(private http: HttpClient) {}

  loadData(): void {
    this.http.get<DataType[]>(`${this.apiUrl}/data`)
      .subscribe(data => this.dataSignal.set(data));
  }

  // Or use toSignal for reactive queries
  users = toSignal(this.http.get<User[]>(`${this.apiUrl}/users`), {
    initialValue: []
  });
}
```

### 3. **State Management Service**

**Angular 12-15**
```typescript
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

interface AppState {
  user: User | null;
  loading: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class StateService {
  private stateSubject = new BehaviorSubject<AppState>({
    user: null,
    loading: false
  });

  state$: Observable<AppState> = this.stateSubject.asObservable();

  updateUser(user: User): void {
    this.stateSubject.next({
      ...this.stateSubject.value,
      user
    });
  }
}
```

**Angular 20+ (Signals)**
```typescript
import { Injectable, computed, signal } from '@angular/core';

interface AppState {
  user: User | null;
  loading: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class StateService {
  private state = signal<AppState>({
    user: null,
    loading: false
  });

  // Readonly access
  readonly user = computed(() => this.state().user);
  readonly loading = computed(() => this.state().loading);
  readonly isAuthenticated = computed(() => !!this.state().user);

  updateUser(user: User): void {
    this.state.update(s => ({ ...s, user }));
  }

  setLoading(loading: boolean): void {
    this.state.update(s => ({ ...s, loading }));
  }
}
```

### 4. **Dependency Injection**

**Constructor Injection (All Versions)**
```typescript
constructor(
  private http: HttpClient,
  private router: Router,
  @Optional() private config: AppConfig
) {}
```

**inject() Function (Angular 16+)**
```typescript
import { inject } from '@angular/core';

export class MyService {
  private http = inject(HttpClient);
  private router = inject(Router);
}
```

### 5. **Service Scoping**

**Root Level (Singleton)**
```typescript
@Injectable({
  providedIn: 'root'
})
```

**Module Level**
```typescript
@Injectable()
// Provide in module:
providers: [MyService]
```

**Component Level**
```typescript
@Component({
  providers: [MyService] // New instance per component
})
```

### 6. **Testing Services**

```typescript
import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { DataService } from './data.service';

describe('DataService', () => {
  let service: DataService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [DataService]
    });
    service = TestBed.inject(DataService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should fetch data', () => {
    const mockData = [{ id: 1, name: 'Test' }];

    service.getData().subscribe(data => {
      expect(data).toEqual(mockData);
    });

    const req = httpMock.expectOne('api/data');
    expect(req.request.method).toBe('GET');
    req.flush(mockData);
  });
});
```

## Service Types

**Data Services**
- HTTP API communication
- CRUD operations
- Caching strategies

**State Management Services**
- Application state
- User session
- Feature toggles

**Utility Services**
- Logging
- Analytics
- Storage (localStorage/sessionStorage)

**Business Logic Services**
- Domain logic
- Calculations
- Validation rules

## Best Practices

1. **Single Responsibility**: One service, one purpose
2. **Immutability**: Don't mutate state directly
3. **Error Handling**: Always handle HTTP errors
4. **Type Safety**: Explicit types for all methods
5. **Testing**: Unit tests for all public methods
6. **RxJS Cleanup**: Unsubscribe or use takeUntil/takeUntilDestroyed
7. **Caching**: Use shareReplay for expensive operations

## What to Generate

1. **Service TypeScript File** - Service class with @Injectable
2. **Service Spec File** - Jasmine unit tests
3. **Interface/Model Files** - TypeScript interfaces for data types
4. **Module Provider** (if needed) - Add to module providers

Generate production-ready, type-safe Angular services with proper error handling and testing.
