---
description: Create a new Angular pipe for data transformation
model: claude-sonnet-4-5
---

Generate a new Angular pipe following Angular best practices.

## Pipe Specification

$ARGUMENTS

## Angular Pipe Patterns

### 1. **Pure Pipe (Default)**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'truncate',
  standalone: true
})
export class TruncatePipe implements PipeTransform {
  transform(value: string, limit: number = 50, ellipsis: string = '...'): string {
    if (!value) return '';
    if (value.length <= limit) return value;
    return value.substring(0, limit) + ellipsis;
  }
}

// Usage: {{ text | truncate:100:'...' }}
```

### 2. **Impure Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'filter',
  pure: false, // Re-runs on every change detection
  standalone: true
})
export class FilterPipe implements PipeTransform {
  transform<T>(items: T[], searchText: string, property: keyof T): T[] {
    if (!items || !searchText) return items;

    return items.filter(item =>
      String(item[property])
        .toLowerCase()
        .includes(searchText.toLowerCase())
    );
  }
}

// Usage: *ngFor="let item of items | filter:searchText:'name'"
```

### 3. **Async Pipe Alternative (Custom)**

```typescript
import { Pipe, PipeTransform } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Pipe({
  name: 'loadingState',
  standalone: true
})
export class LoadingStatePipe implements PipeTransform {
  transform<T>(observable: Observable<T>): Observable<{
    loading: boolean;
    data?: T;
    error?: any;
  }> {
    return observable.pipe(
      map(data => ({ loading: false, data })),
      // Add error handling, loading state logic
    );
  }
}
```

### 4. **Date Formatting Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'timeAgo',
  standalone: true
})
export class TimeAgoPipe implements PipeTransform {
  transform(value: Date | string | number): string {
    if (!value) return '';

    const date = new Date(value);
    const now = new Date();
    const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

    const intervals = {
      year: 31536000,
      month: 2592000,
      week: 604800,
      day: 86400,
      hour: 3600,
      minute: 60,
      second: 1
    };

    for (const [unit, secondsInUnit] of Object.entries(intervals)) {
      const interval = Math.floor(seconds / secondsInUnit);
      if (interval >= 1) {
        return `${interval} ${unit}${interval !== 1 ? 's' : ''} ago`;
      }
    }

    return 'just now';
  }
}

// Usage: {{ post.createdAt | timeAgo }}
```

### 5. **Number Formatting Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'fileSize',
  standalone: true
})
export class FileSizePipe implements PipeTransform {
  transform(bytes: number, decimals: number = 2): string {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return (
      parseFloat((bytes / Math.pow(k, i)).toFixed(decimals)) + ' ' + sizes[i]
    );
  }
}

// Usage: {{ file.size | fileSize }}
```

### 6. **Safe HTML Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Pipe({
  name: 'safeHtml',
  standalone: true
})
export class SafeHtmlPipe implements PipeTransform {
  constructor(private sanitizer: DomSanitizer) {}

  transform(value: string): SafeHtml {
    return this.sanitizer.sanitize(1, value) || '';
  }
}

// Usage: <div [innerHTML]="htmlContent | safeHtml"></div>
```

### 7. **Search Highlight Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Pipe({
  name: 'highlight',
  standalone: true
})
export class HighlightPipe implements PipeTransform {
  constructor(private sanitizer: DomSanitizer) {}

  transform(value: string, search: string): SafeHtml {
    if (!search || !value) {
      return value;
    }

    const regex = new RegExp(search, 'gi');
    const highlighted = value.replace(
      regex,
      match => `<mark>${match}</mark>`
    );

    return this.sanitizer.sanitize(1, highlighted) || '';
  }
}

// Usage: <div [innerHTML]="text | highlight:searchTerm"></div>
```

### 8. **Array Sorting Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

type SortOrder = 'asc' | 'desc';

@Pipe({
  name: 'sortBy',
  pure: false,
  standalone: true
})
export class SortByPipe implements PipeTransform {
  transform<T>(array: T[], property: keyof T, order: SortOrder = 'asc'): T[] {
    if (!array || !property) return array;

    return [...array].sort((a, b) => {
      const aVal = a[property];
      const bVal = b[property];

      if (aVal < bVal) return order === 'asc' ? -1 : 1;
      if (aVal > bVal) return order === 'asc' ? 1 : -1;
      return 0;
    });
  }
}

// Usage: *ngFor="let user of users | sortBy:'name':'asc'"
```

### 9. **Memoized Pipe (Performance)**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'memoize',
  standalone: true
})
export class MemoizePipe implements PipeTransform {
  private cache = new Map<string, any>();

  transform<T, R>(
    value: T,
    transformFn: (value: T) => R,
    cacheKey?: string
  ): R {
    const key = cacheKey || JSON.stringify(value);

    if (this.cache.has(key)) {
      return this.cache.get(key);
    }

    const result = transformFn(value);
    this.cache.set(key, result);

    return result;
  }
}
```

### 10. **Enum to Array Pipe**

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'enumToArray',
  standalone: true
})
export class EnumToArrayPipe implements PipeTransform {
  transform(enumObj: any): { key: string; value: any }[] {
    return Object.keys(enumObj)
      .filter(key => isNaN(Number(key)))
      .map(key => ({ key, value: enumObj[key] }));
  }
}

// Usage:
// enum Status { Active = 'active', Inactive = 'inactive' }
// *ngFor="let status of Status | enumToArray"
```

## Pipe Types

### Pure Pipes (Default)
- Run only when input value changes
- Performance optimized
- Stateless transformations
- Most common use case

### Impure Pipes
- Run on every change detection
- Can detect changes in objects/arrays
- Performance impact
- Use sparingly

## Best Practices

1. **Keep Pipes Pure**: Default to pure pipes for better performance
2. **Avoid Complex Logic**: Keep transformations simple and fast
3. **Type Safety**: Use generics for type-safe pipes
4. **Memoization**: Cache expensive computations
5. **Error Handling**: Handle null/undefined gracefully
6. **Side Effects**: Avoid side effects in transform method
7. **Standalone**: Use standalone: true in Angular 16+

## Performance Considerations

**Pure Pipes (Fast)**
```typescript
// ✅ Good - runs only when input changes
{{ value | uppercase }}
{{ price | currency }}
```

**Impure Pipes (Slow)**
```typescript
// ⚠️ Careful - runs on every change detection
{{ items | filter:searchText }}
{{ items | sortBy:'name' }}
```

**Alternative to Impure Pipes**
```typescript
// Use computed signals (Angular 16+)
items = signal<Item[]>([]);
searchText = signal('');

filteredItems = computed(() =>
  this.items().filter(item =>
    item.name.includes(this.searchText())
  )
);
```

## Common Pipe Examples

### Currency with Locale
```typescript
{{ price | currency:'USD':'symbol':'1.2-2' }}
```

### Date Formatting
```typescript
{{ date | date:'short' }}
{{ date | date:'yyyy-MM-dd' }}
{{ date | date:'fullDate' }}
```

### Number Formatting
```typescript
{{ value | number:'1.2-2' }} // 1 integer, 2-2 decimals
{{ 0.5 | percent }} // 50%
```

### JSON Pipe (Debugging)
```typescript
<pre>{{ object | json }}</pre>
```

## Testing Pipes

```typescript
import { TruncatePipe } from './truncate.pipe';

describe('TruncatePipe', () => {
  let pipe: TruncatePipe;

  beforeEach(() => {
    pipe = new TruncatePipe();
  });

  it('should create an instance', () => {
    expect(pipe).toBeTruthy();
  });

  it('should truncate long text', () => {
    const longText = 'This is a very long text that should be truncated';
    const result = pipe.transform(longText, 20, '...');
    expect(result).toBe('This is a very long ...');
  });

  it('should not truncate short text', () => {
    const shortText = 'Short';
    const result = pipe.transform(shortText, 20);
    expect(result).toBe('Short');
  });

  it('should handle empty string', () => {
    expect(pipe.transform('', 20)).toBe('');
  });
});
```

## What to Generate

1. **Pipe TypeScript File** - Pipe class with transform method
2. **Pipe Spec File** - Unit tests
3. **Usage Examples** - Template syntax examples
4. **Performance Notes** - Pure vs impure considerations

Generate efficient, type-safe Angular pipes with proper testing and performance optimization.
