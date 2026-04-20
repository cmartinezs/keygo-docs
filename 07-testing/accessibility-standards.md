# Testing: Accessibility Standards (WCAG 2.1 AA)

**Fase:** 07-testing | **Audiencia:** Frontend devs, QA, designers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Accessibility Goals](#accessibility-goals)
2. [WCAG 2.1 AA Checklist](#wcag-21-aa-checklist)
3. [Keyboard Navigation](#keyboard-navigation)
4. [Screen Reader Compatibility](#screen-reader-compatibility)
5. [Color & Contrast](#color--contrast)
6. [Testing Tools & Process](#testing-tools--process)

---

## Accessibility Goals

KeyGo UI must be usable by:

- **Keyboard-only users** (no mouse)
- **Screen reader users** (NVDA, JAWS, VoiceOver)
- **Vision impaired** (high contrast, text sizing)
- **Motor impaired** (large clickable areas)
- **Cognitive impaired** (simple, predictable navigation)

**Target:** WCAG 2.1 Level AA compliance (11 of 13 criteria)

---

## WCAG 2.1 AA Checklist

### Perceivable

| Criterion | Implementation |
|-----------|-----------------|
| 1.1 Text Alternatives | All images have alt text or aria-label |
| 1.2 Captions & Audio | N/A (no video) |
| 1.3 Adaptable | Forms use `<label for="input-id">` |
| 1.4 Distinguishable | Contrast ratio >= 4.5:1 (text), 3:1 (UI components) |

### Operable

| Criterion | Implementation |
|-----------|-----------------|
| 2.1 Keyboard Accessible | All functionality via Tab, Enter, Escape, Arrow keys |
| 2.2 Enough Time | No auto-logout < 60 min; focus visible (outline) |
| 2.3 Seizures | No flashing > 3x/sec |
| 2.4 Navigable | Skip links, heading hierarchy (h1 > h2 > h3) |
| 2.5 Input Modalities | Buttons >= 44x44 px, touch targets large |

### Understandable

| Criterion | Implementation |
|-----------|-----------------|
| 3.1 Readable | Language declared in <html lang="en"> |
| 3.2 Predictable | Form submit only on user action, no auto-redirect |
| 3.3 Input Assistance | Error messages clear, linked to fields |

### Robust

| Criterion | Implementation |
|-----------|-----------------|
| 4.1 Compatible | Valid HTML, ARIA landmarks, semantic tags |

---

## Keyboard Navigation

### Keys Supported

| Key | Behavior |
|-----|----------|
| **Tab** | Move forward through focusable elements |
| **Shift+Tab** | Move backward |
| **Enter** | Activate button, submit form |
| **Escape** | Close modal, cancel form |
| **Arrow Keys** | Navigate menu/list items |
| **Space** | Toggle checkbox, expand menu |

### Implementation

```html
<!-- Buttons always focusable -->
<button>Submit</button>

<!-- Links always focusable -->
<a href="/dashboard">Go to dashboard</a>

<!-- Custom components: tabindex="0" to include in tab order -->
<div role="button" tabindex="0" @click="handleClick">Custom button</div>

<!-- Skip link (first focusable element) -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<!-- Focus visible (no outline removal!) -->
button:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}
```

### Testing

```bash
# Navigate entire page using only keyboard
1. Tab through all interactive elements
2. Escape should close any open modals
3. Can reach all content without mouse
```

---

## Screen Reader Compatibility

### Semantic HTML

```html
<!-- GOOD: semantic tags -->
<nav>Navigation menu</nav>
<main>Main content</main>
<aside>Sidebar</aside>
<footer>Footer info</footer>

<!-- BAD: divs don't convey structure -->
<div class="nav">Navigation menu</div>
<div class="content">Main content</div>
```

### ARIA Landmarks

```html
<nav role="navigation" aria-label="Main Navigation">
  <ul>
    <li><a href="/">Home</a></li>
    <li><a href="/login">Login</a></li>
  </ul>
</nav>

<main role="main" aria-label="Main content">
  <!-- Page content -->
</main>

<aside role="complementary" aria-label="Sidebar">
  <!-- Related links -->
</aside>
```

### Form Labels

```html
<!-- GOOD: associated label -->
<label for="email">Email Address</label>
<input id="email" type="email" required>

<!-- GOOD: aria-label if no visible label -->
<input aria-label="Search query" type="text" placeholder="Search">

<!-- BAD: disconnected label -->
<label>Email Address</label>
<input type="email">
```

### Dynamic Content Announcements

```jsx
// When submitting a form, announce success/error
const [message, setMessage] = useState('')

return (
  <>
    {/* Role alert announces changes immediately */}
    <div role="alert" aria-live="polite">
      {message}
    </div>
    
    <button onClick={() => setMessage('Form submitted successfully')}>
      Submit
    </button>
  </>
)
```

### Testing

```bash
# Test with screen reader
# macOS: VoiceOver (Cmd+F5)
# Windows: NVDA (free)
# Online: JAWS trial

# Check:
1. All buttons/links announced with purpose
2. Form fields announced with labels
3. Errors announced immediately
4. Success messages announced
```

---

## Color & Contrast

### Contrast Ratios

| Element | Minimum | Preferred |
|---------|---------|-----------|
| **Body text** | 4.5:1 | 7:1 |
| **Large text (18px+)** | 3:1 | 5:1 |
| **UI components** | 3:1 | 4.5:1 |
| **Graphical objects** | 3:1 | 5:1 |

### Testing

```bash
# Tool: WebAIM Contrast Checker
# https://webaim.org/resources/contrastchecker/

# Example: #FFFFFF on #0066CC
# Ratio: 8.6:1 ✓ WCAG AAA (highest standard)
```

### Implementation

```css
/* Ensure sufficient contrast */
:root {
  --text-primary: #222222;  /* on white: 17.5:1 ✓ */
  --text-secondary: #666666;  /* on white: 5.74:1 ✓ */
  --button-primary: #0066CC;  /* on white: 8.6:1 ✓ */
  --error: #C41E3A;  /* on white: 5.2:1 ✓ */
}

/* Don't rely on color alone */
.error {
  color: var(--error);
}

.error::before {
  content: "❌ ";  /* Icon + text */
}
```

### Color Blindness Simulation

```bash
# Tool: Accessible Colors
# https://accessible-colors.com/

# Test deuteranopia, protanopia, tritanopia
# Verify distinctions remain clear
```

---

## Testing Tools & Process

### Automated Testing (CI)

```bash
# axe DevTools
npm install -D @axe-core/react
npm run test:a11y

# Pa11y
pa11y https://keygo.example.com

# LightHouse (in Chrome)
lighthouse https://keygo.example.com --output json
```

### Manual Testing Checklist

```
[ ] Tab through page: can reach all interactive elements
[ ] Escape closes modals
[ ] Screen reader: all content announced
[ ] Color contrast: 4.5:1 for text
[ ] Text resize: 200% zoom readable
[ ] Skip link present
[ ] Form labels associated with inputs
[ ] Error messages announced
[ ] Focus visible (outline present)
```

### Testing Template

```html
<!-- Page template with a11y baseline -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page Title</title>
</head>
<body>
  <!-- Skip link (first focusable) -->
  <a href="#main-content" class="skip-link">Skip to main content</a>
  
  <!-- Navigation with landmark -->
  <nav aria-label="Main Navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/login">Login</a></li>
    </ul>
  </nav>
  
  <!-- Main content with role + aria-label -->
  <main id="main-content" role="main">
    <h1>Page Heading</h1>
    
    <!-- Form with labels -->
    <form>
      <label for="email">Email</label>
      <input id="email" type="email" required>
      
      <button type="submit">Submit</button>
    </form>
    
    <!-- Alerts announced -->
    <div role="alert" aria-live="polite">
      <!-- Success/error messages -->
    </div>
  </main>
  
  <!-- Footer -->
  <footer>
    <p>&copy; 2026 KeyGo</p>
  </footer>
</body>
</html>
```

---

## Véase También

- **frontend-architecture.md** — Tech stack (React, shadcn supports a11y)
- **frontend-project-structure.md** — Component organization
- **security-testing-plan.md** — Testing strategy overall

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Frontend/QA | **Licencia:** Keygo Docs
