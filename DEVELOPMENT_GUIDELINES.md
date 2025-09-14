# Development Guidelines - ThriveCopilot

## Repository Structure Alignment

### Current Setup
- **Local Root**: `/Users/davemathew/Documents/thrivecopilot/`
- **GitHub Repo**: `thrivecopilot/NutriPlanr`
- **Website**: `nutriplanr.com` (GitHub Pages)

### Key Principle
**The local `thrivecopilot/` directory IS the GitHub repository root.** 
- No nested `nutriplanr/` subdirectories
- All files go directly in the root
- Website files must be in root for GitHub Pages

### File Organization

#### Website Files (GitHub Pages)
- `index.html` - Main landing page
- `styles.css` - Website styling
- `script.js` - Website JavaScript
- `CNAME` - Custom domain configuration
- `package.json` - Website dependencies

#### iOS App Files
- `ContentView.swift` - Main app view
- `nutriplanrApp.swift` - App entry point
- `Assets.xcassets/` - App icons and assets
- `Models/` - Data models
- `Views/` - SwiftUI views
- `Services/` - Business logic
- `Utilities/` - Helper functions
- `ViewModels/` - View state management
- `nutriplanr.xcodeproj/` - Xcode project
- `nutriplanrTests/` - Unit tests
- `nutriplanrUITests/` - UI tests

#### Development Files
- `PRD.md` - Product requirements
- `DEVELOPMENT_PLAN.md` - Development roadmap
- `MEAL_PLAN_DEVELOPMENT_PLAN.md` - Specific feature plan
- `DEVELOPMENT_GUIDELINES.md` - This file

### Development Workflow

#### Before Making Changes
1. **Always check current directory**: `pwd` should show `/Users/davemathew/Documents/thrivecopilot/`
2. **Verify git status**: `git status` to see what's changed
3. **Check file locations**: Files should be in root, not in subdirectories

#### When Adding New Files
- **Website files**: Add directly to root (`/Users/davemathew/Documents/thrivecopilot/`)
- **iOS app files**: Add directly to root (`/Users/davemathew/Documents/thrivecopilot/`)
- **Never create**: `nutriplanr/` subdirectory

#### Before Committing
1. **Verify structure**: `ls -la` should show files in root
2. **Check git status**: `git status` should show files in root
3. **Test locally**: Ensure website works if adding website files

#### Git Commands
```bash
# Always run from /Users/davemathew/Documents/thrivecopilot/
cd /Users/davemathew/Documents/thrivecopilot/
git add -A
git commit -m "Descriptive message"
git push origin main
```

### Common Mistakes to Avoid

❌ **Don't create nested directories:**
```
thrivecopilot/
└── nutriplanr/          ← WRONG!
    ├── index.html
    └── styles.css
```

✅ **Keep everything in root:**
```
thrivecopilot/
├── index.html           ← CORRECT!
├── styles.css
└── ContentView.swift
```

### Verification Commands

```bash
# Check current directory
pwd
# Should output: /Users/davemathew/Documents/thrivecopilot/

# Check file structure
ls -la
# Should show index.html, styles.css, ContentView.swift in root

# Check git status
git status
# Should show files in root, not in subdirectories

# Check remote repository
git ls-tree origin/main
# Should show files in root
```

### Future Development

When working on NutriPlanr:
1. **Always work in**: `/Users/davemathew/Documents/thrivecopilot/`
2. **Never create**: `nutriplanr/` subdirectory
3. **Add files directly**: To the root directory
4. **Verify before commit**: Structure is correct
5. **Test website**: If modifying website files

This ensures the local structure matches GitHub and GitHub Pages works correctly.
