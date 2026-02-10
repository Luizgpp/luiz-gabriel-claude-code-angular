---
description: Create a new Angular directive with best practices
model: claude-sonnet-4-5
---

Generate a new Angular directive following Angular best practices.

## Directive Specification

$ARGUMENTS

## Angular Directive Patterns

### 1. **Attribute Directive (Angular 12-15)**

```typescript
import { Directive, ElementRef, HostListener, Input, Renderer2 } from '@angular/core';

@Directive({
  selector: '[appHighlight]'
})
export class HighlightDirective {
  @Input() appHighlight = 'yellow';
  @Input() defaultColor = 'transparent';

  constructor(
    private el: ElementRef,
    private renderer: Renderer2
  ) {}

  @HostListener('mouseenter') onMouseEnter() {
    this.highlight(this.appHighlight);
  }

  @HostListener('mouseleave') onMouseLeave() {
    this.highlight(this.defaultColor);
  }

  private highlight(color: string): void {
    this.renderer.setStyle(this.el.nativeElement, 'backgroundColor', color);
  }
}
```

### 2. **Standalone Directive (Angular 16+)**

```typescript
import { Directive, ElementRef, HostListener, input, effect, Renderer2 } from '@angular/core';

@Directive({
  selector: '[appHighlight]',
  standalone: true
})
export class HighlightDirective {
  // Signal inputs (Angular 16+)
  highlightColor = input<string>('yellow');
  defaultColor = input<string>('transparent');

  constructor(
    private el: ElementRef,
    private renderer: Renderer2
  ) {}

  @HostListener('mouseenter') onMouseEnter() {
    this.highlight(this.highlightColor());
  }

  @HostListener('mouseleave') onMouseLeave() {
    this.highlight(this.defaultColor());
  }

  private highlight(color: string): void {
    this.renderer.setStyle(this.el.nativeElement, 'backgroundColor', color);
  }
}
```

### 3. **Structural Directive**

```typescript
import { Directive, Input, TemplateRef, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[appUnless]',
  standalone: true
})
export class UnlessDirective {
  private hasView = false;

  constructor(
    private templateRef: TemplateRef<any>,
    private viewContainer: ViewContainerRef
  ) {}

  @Input() set appUnless(condition: boolean) {
    if (!condition && !this.hasView) {
      this.viewContainer.createEmbeddedView(this.templateRef);
      this.hasView = true;
    } else if (condition && this.hasView) {
      this.viewContainer.clear();
      this.hasView = false;
    }
  }
}

// Usage: <div *appUnless="isLoggedIn">Please log in</div>
```

### 4. **Form Validation Directive**

```typescript
import { Directive, Input } from '@angular/core';
import { AbstractControl, NG_VALIDATORS, ValidationErrors, Validator } from '@angular/forms';

@Directive({
  selector: '[appForbiddenName]',
  providers: [{
    provide: NG_VALIDATORS,
    useExisting: ForbiddenNameDirective,
    multi: true
  }],
  standalone: true
})
export class ForbiddenNameDirective implements Validator {
  @Input() appForbiddenName = '';

  validate(control: AbstractControl): ValidationErrors | null {
    return this.appForbiddenName
      ? this.forbiddenNameValidator(control)
      : null;
  }

  private forbiddenNameValidator(control: AbstractControl): ValidationErrors | null {
    const forbidden = new RegExp(this.appForbiddenName, 'i').test(control.value);
    return forbidden ? { forbiddenName: { value: control.value } } : null;
  }
}
```

### 5. **Host Binding Directive**

```typescript
import { Directive, HostBinding, HostListener, Input } from '@angular/core';

@Directive({
  selector: '[appDropzone]',
  standalone: true
})
export class DropzoneDirective {
  @HostBinding('class.dragover') isDragOver = false;

  @Input() appDropzone: (files: FileList) => void = () => {};

  @HostListener('dragover', ['$event'])
  onDragOver(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = true;
  }

  @HostListener('dragleave', ['$event'])
  onDragLeave(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = false;
  }

  @HostListener('drop', ['$event'])
  onDrop(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = false;

    const files = event.dataTransfer?.files;
    if (files && files.length > 0) {
      this.appDropzone(files);
    }
  }
}
```

### 6. **Click Outside Directive**

```typescript
import { Directive, ElementRef, EventEmitter, HostListener, Output } from '@angular/core';

@Directive({
  selector: '[appClickOutside]',
  standalone: true
})
export class ClickOutsideDirective {
  @Output() appClickOutside = new EventEmitter<void>();

  constructor(private elementRef: ElementRef) {}

  @HostListener('document:click', ['$event.target'])
  onClick(target: HTMLElement): void {
    const clickedInside = this.elementRef.nativeElement.contains(target);
    if (!clickedInside) {
      this.appClickOutside.emit();
    }
  }
}
```

### 7. **Lazy Load Image Directive**

```typescript
import { Directive, ElementRef, Input, OnInit, Renderer2 } from '@angular/core';

@Directive({
  selector: '[appLazyLoad]',
  standalone: true
})
export class LazyLoadDirective implements OnInit {
  @Input() appLazyLoad = '';
  @Input() placeholder = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

  private intersectionObserver?: IntersectionObserver;

  constructor(
    private el: ElementRef<HTMLImageElement>,
    private renderer: Renderer2
  ) {}

  ngOnInit(): void {
    // Set placeholder
    this.renderer.setAttribute(this.el.nativeElement, 'src', this.placeholder);

    // Create intersection observer
    this.intersectionObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadImage();
        }
      });
    });

    this.intersectionObserver.observe(this.el.nativeElement);
  }

  private loadImage(): void {
    this.renderer.setAttribute(this.el.nativeElement, 'src', this.appLazyLoad);
    this.intersectionObserver?.disconnect();
  }
}
```

## Directive Types

### Attribute Directives
- Modify element appearance
- Add behavior to elements
- DOM manipulation
- Event handling

### Structural Directives
- Add/remove DOM elements
- Conditional rendering
- Loop rendering
- Custom control flow

### Component Directives
- Components are directives with templates
- Most common type
- Encapsulated view

## Best Practices

1. **Use Renderer2**: Never manipulate DOM directly (`nativeElement.style.x = y`)
2. **HostListener/HostBinding**: Declarative event handling and property binding
3. **Input Naming**: Use directive selector as input name for cleaner syntax
4. **Lifecycle Hooks**: Implement OnInit, OnDestroy for setup/cleanup
5. **Type Safety**: Strongly type all inputs and outputs
6. **Standalone**: Prefer standalone directives in Angular 16+
7. **Performance**: Be careful with expensive operations in directives

## Common Use Cases

**UI Enhancements**
- Tooltips
- Animations
- Drag and drop
- Lazy loading

**Form Helpers**
- Custom validators
- Input masking
- Auto-focus
- Character counters

**Accessibility**
- ARIA attributes
- Keyboard navigation
- Focus management
- Screen reader support

**Performance**
- Virtual scrolling
- Image lazy loading
- Intersection observers
- Debounce/throttle

## Testing Directives

```typescript
import { Component, DebugElement } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { HighlightDirective } from './highlight.directive';

@Component({
  template: `<div appHighlight [highlightColor]="color">Test</div>`,
  standalone: true,
  imports: [HighlightDirective]
})
class TestComponent {
  color = 'yellow';
}

describe('HighlightDirective', () => {
  let fixture: ComponentFixture<TestComponent>;
  let divEl: DebugElement;

  beforeEach(() => {
    fixture = TestBed.configureTestingModule({
      imports: [TestComponent]
    }).createComponent(TestComponent);

    divEl = fixture.debugElement.query(By.css('div'));
    fixture.detectChanges();
  });

  it('should highlight on mouseenter', () => {
    divEl.triggerEventHandler('mouseenter', null);
    fixture.detectChanges();

    expect(divEl.nativeElement.style.backgroundColor).toBe('yellow');
  });
});
```

## What to Generate

1. **Directive TypeScript File** - Directive class with decorator
2. **Directive Spec File** - Unit tests
3. **Usage Example** - How to use in templates
4. **Module/Standalone Import** - How to make available

Generate reusable, performant Angular directives with proper DOM manipulation and testing.
