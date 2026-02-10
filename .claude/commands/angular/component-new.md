---
description: Create a new Angular component with TypeScript and best practices
model: claude-sonnet-4-5
---

Generate a new Angular component following Angular best practices.

## Component Specification

$ARGUMENTS

## Angular Version Detection

Detect the Angular version from package.json and apply appropriate patterns:
- **Angular 12-15**: Use older patterns (CommonModule, Component decorator with standalone: false)
- **Angular 16-19**: Transition patterns (standalone option available)
- **Angular 20+**: Modern patterns (standalone by default, signal-based)

## Angular TypeScript Standards

### 1. **Component Structure**

**Angular 12-15 (Module-based)**
```typescript
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-component-name',
  templateUrl: './component-name.component.html',
  styleUrls: ['./component-name.component.scss']
})
export class ComponentNameComponent implements OnInit {
  constructor() { }

  ngOnInit(): void {
  }
}
```

**Angular 20+ (Standalone + Signals)**
```typescript
import { Component, signal, computed } from '@angular/core';

@Component({
  selector: 'app-component-name',
  standalone: true,
  imports: [],
  templateUrl: './component-name.component.html',
  styleUrls: ['./component-name.component.scss']
})
export class ComponentNameComponent {
  // Use signals for reactive state
  count = signal(0);
  doubleCount = computed(() => this.count() * 2);
}
```

### 2. **TypeScript Best Practices**
- Strict mode enabled
- Explicit types for properties and methods
- Interface for component inputs/outputs
- NO `any` types
- Use proper Angular types (OnInit, AfterViewInit, etc.)

### 3. **State Management**

**Angular 12-15**
- RxJS BehaviorSubject/Subject for state
- Services with Observables
- NgRx for complex state

**Angular 20+**
- Signals for reactive state
- Signal-based state management
- RxJS interop with toSignal/toObservable

### 4. **Change Detection**

**All Versions**
- Use OnPush change detection strategy for better performance
- Immutable data patterns
- Track functions for ngFor loops

### 5. **Lifecycle Hooks**

**Angular 12-15**
```typescript
implements OnInit, OnDestroy {
  private destroy$ = new Subject<void>();

  ngOnInit(): void {
    // Setup
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

**Angular 20+**
```typescript
import { DestroyRef, inject } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

constructor() {
  const destroyRef = inject(DestroyRef);
  // Automatic cleanup with takeUntilDestroyed()
}
```

### 6. **Forms**

**Reactive Forms (All Versions)**
```typescript
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

formGroup: FormGroup;

constructor(private fb: FormBuilder) {
  this.formGroup = this.fb.group({
    name: ['', [Validators.required, Validators.minLength(3)]],
    email: ['', [Validators.required, Validators.email]]
  });
}
```

**Angular 20+ Typed Forms**
```typescript
import { FormControl, FormGroup, NonNullableFormBuilder } from '@angular/forms';

interface UserForm {
  name: FormControl<string>;
  email: FormControl<string>;
}

formGroup: FormGroup<UserForm>;
```

### 7. **Performance Optimization**

- **OnPush Change Detection**: Reduce unnecessary checks
- **trackBy Functions**: For ngFor loops
- **Lazy Loading**: Route-level code splitting
- **Pure Pipes**: For data transformation
- **Virtual Scrolling**: For large lists (CDK)

### 8. **Testing**

**Component Test Template**
```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ComponentNameComponent } from './component-name.component';

describe('ComponentNameComponent', () => {
  let component: ComponentNameComponent;
  let fixture: ComponentFixture<ComponentNameComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      // Angular 12-15: declarations
      declarations: [ ComponentNameComponent ],
      // Angular 20+: imports
      imports: [ ComponentNameComponent ]
    }).compileComponents();

    fixture = TestBed.createComponent(ComponentNameComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
```

## What to Generate

1. **Component TypeScript File** - Component class with proper decorators
2. **Template HTML File** - Semantic HTML with Angular directives
3. **Styles SCSS File** - Component-scoped styles
4. **Spec Test File** - Jasmine/Karma unit tests
5. **Module Update** (Angular 12-15 only) - Add to declarations

## Code Quality Standards

**Structure**
- Feature-based folder organization
- Component/Service/Module co-location
- Barrel exports (index.ts)
- Clear naming conventions (*.component.ts)

**TypeScript**
- Explicit types for all properties
- Interface for @Input/@Output
- Proper generics usage
- Strict null checks

**Template**
- Semantic HTML elements
- Async pipe for Observables
- OnPush-friendly patterns
- Accessibility attributes (ARIA)

**Accessibility**
- ARIA labels and roles
- Keyboard navigation
- Focus management
- Screen reader support

## Angular-Specific Patterns

**Smart vs Presentational Components**
- **Smart (Container)**: Data fetching, state management, routing
- **Presentational (Dumb)**: Pure UI, inputs/outputs only

**Component Communication**
- **@Input()**: Parent to child
- **@Output()**: Child to parent (EventEmitter)
- **Services**: Cross-component communication
- **State Management**: NgRx, Akita, or Signals (v20+)

**RxJS Patterns**
- Subscription management (takeUntil, takeUntilDestroyed)
- Operators: map, filter, switchMap, combineLatest
- Error handling: catchError, retry
- ShareReplay for caching

## Version-Specific Features

**Angular 12-15**
- ViewChild/ContentChild queries
- TemplateRef and ViewContainerRef
- Module-based architecture
- Providers in module

**Angular 16-19**
- Standalone components option
- inject() function
- DestroyRef
- Typed forms

**Angular 20+**
- Signals by default
- Signal inputs/outputs
- Signal queries (viewChild, contentChild)
- Built-in control flow (@if, @for, @switch)
- Defer loading (@defer)

Generate production-ready, performant, and accessible Angular components following the appropriate version's best practices.
