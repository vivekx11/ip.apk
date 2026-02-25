# Shop Owner App - Complete UI/UX Design Specification

## 🎨 COLOR SYSTEM

### Primary Colors
```dart
// Primary Palette
static const primaryViolet = Color(0xFF7C3AED);    // Main brand, buttons, appbar
static const darkViolet = Color(0xFF4C1D95);       // Headings, bold text
static const lightViolet = Color(0xFFEDE9FE);      // Card backgrounds, chips
static const softWhite = Color(0xFFF5F3FF);        // Page background
static const pureWhite = Color(0xFFFFFFFF);        // Cards, inputs
```

### Semantic / Status Colors
```dart
// Success
static const successGreen = Color(0xFF16A34A);     // Delivered, Paid, Active
static const successLight = Color(0xFFDCFCE7);     // Success badge background

// Warning
static const warningOrange = Color(0xFFEA580C);    // Pending, Low stock
static const warningLight = Color(0xFFFFEDD5);     // Pending badge background

// Error
static const errorRed = Color(0xFFDC2626);         // Cancelled, Delete, Failed
static const errorLight = Color(0xFFFEE2E2);       // Error badge background

// Info
static const infoBlue = Color(0xFF2563EB);         // Info, Notes, Tips
static const infoLight = Color(0xFFDBEAFE);        // Info badge background
```

### Text Colors
```dart
static const primaryText = Color(0xFF1E1B4B);      // Main content
static const secondaryText = Color(0xFF6B7280);    // Subtitles, hints
static const disabledText = Color(0xFF9CA3AF);     // Placeholder, disabled
```

---

## 📱 SCREEN DESIGNS

### 1. SPLASH SCREEN

**Layout:**
```
┌─────────────────────────┐
│   Background: #7C3AED   │
│                         │
│         [LOGO]          │ ← White shop icon (80x80)
│                         │
│      Shop Owner         │ ← White, Bold, 28px
│         App             │
│                         │
│      ● ● ●              │ ← Animated loading dots (white)
│                         │
└─────────────────────────┘
```

**Specifications:**
- Full screen violet background (#7C3AED)
- Logo centered vertically and horizontally
- App name below logo with 16px spacing
- Loading animation at bottom (24px from bottom)
- Fade-in animation on logo (300ms)
- Pulse animation on loading dots

---

### 2. LOGIN / REGISTER SCREEN

**Layout:**
```
┌─────────────────────────┐
│   ╭─────────────────╮   │ ← Violet curved header (35% height)
│   │                 │   │   Background: #7C3AED
│   │     [LOGO]      │   │ ← White logo (60x60)
│   │   Welcome Back  │   │ ← White, 24px, Bold
│   ╰─────────────────╯   │
│  ┌───────────────────┐  │ ← White card floating
│  │  Email/Phone      │  │   Shadow: rgba(124,58,237,0.08)
│  │  [____________]   │  │   Border radius: 12px
│  │                   │  │
│  │  Password         │  │
│  │  [____________]👁  │  │ ← Show/hide icon: #8B5CF6
│  │                   │  │
│  │  [  LOGIN  ]      │  │ ← Button: #7C3AED, white text
│  │                   │  │   Border radius: 10px
│  │  Forgot Password? │  │ ← Link: #7C3AED, 12px
│  │                   │  │
│  │  ─── OR ───       │  │ ← Gray divider
│  │                   │  │
│  │  [🔵 Google]      │  │ ← Outlined button
│  │                   │  │
│  │  Don't have acc?  │  │
│  │  Register         │  │ ← Link: #7C3AED, Bold
│  └───────────────────┘  │
└─────────────────────────┘
```

**Specifications:**
- Top curved header: 35% screen height, #7C3AED
- White card: 16px horizontal margin, -40px top offset (floating effect)
- Input fields: white bg, #E5E7EB border, #7C3AED focus border
- Input height: 48px, padding: 12px
- Login button: full width, height 48px, shadow on press
- Google button: white bg, violet border, 48px height
- Text links: #7C3AED, underline on press
- Form validation: real-time with violet border + error text (#DC2626)

---

### 3. DASHBOARD (HOME) SCREEN

**Layout:**
```
┌─────────────────────────┐
│ ☰  Dashboard        🔔  │ ← AppBar: #7C3AED, white icons
├─────────────────────────┤
│ Good Morning, Ahmed 👋  │ ← White text on violet, 18px
│ Let's grow your shop    │ ← White, 14px, opacity 0.9
├─────────────────────────┤
│ ┌─────┐ ┌─────┐        │ ← Stats row (2x2 grid)
│ │ 💰  │ │ 📦  │        │   12px gap between cards
│ │₹5.2K│ │  8  │        │
│ │Sales│ │Pend │        │
│ └─────┘ └─────┘        │
│ ┌─────┐ ┌─────┐        │
│ │ 📊  │ │ ⚠️  │        │
│ │ 45  │ │  3  │        │
│ │Prod │ │Low  │        │
│ └─────┘ └─────┘        │
├─────────────────────────┤
│ Recent Orders           │ ← Section: #4C1D95, 16px, Bold
│ View All →              │ ← Link: #7C3AED, 14px
│                         │
│ ┌───────────────────┐  │ ← Order card
│ │▌#ORD-1234         │  │   Left border: status color
│ │▌Ahmed Khan        │  │   White bg, 12px radius
│ │▌📱 +92-300-xxx    │  │
│ │▌₹850 • 3 items    │  │ ← Price: #7C3AED bold
│ │▌[Pending]    →    │  │ ← Badge + arrow
│ └───────────────────┘  │
│                         │
│ ┌───────────────────┐  │
│ │▌#ORD-1235         │  │
│ │▌Sara Ali          │  │
│ └───────────────────┘  │
├─────────────────────────┤
│ 🏠  📦  📊  👤         │ ← Bottom nav: white bg
│ Home Orders Reports Me │   Active: #7C3AED
└─────────────────────────┘   Inactive: #9CA3AF
```

**Specifications:**
