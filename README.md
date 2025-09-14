# Meal Plan Assistant

A proactive nutrition planning application that focuses on planning and execution rather than reactive tracking. Built with SwiftUI for iOS.

## 🎯 Project Status

**Current Phase**: Phase 1 - Foundation & Core Architecture ✅ **COMPLETED**

## 🏗️ What's Been Built

### ✅ **Core Data Models**
- **User Model**: Complete user profile with height, weight, age, gender, activity level, goals, and dietary preferences
- **Recipe Model**: Comprehensive recipe structure with ingredients, nutritional info, and preparation details
- **MealPlan Model**: Weekly meal planning with daily breakdowns and nutritional targets
- **NutritionalGoal Model**: Goal tracking with progress monitoring and analytics

### ✅ **Architecture & State Management**
- **MVVM Architecture**: Clean separation of concerns with ObservableObject pattern
- **AppStateManager**: Centralized state management with proper data flow
- **Combine Integration**: Reactive state updates and data binding
- **Proper Initialization**: All data structures properly initialized with error handling

### ✅ **Design System**
- **8pt Grid System**: Consistent spacing throughout the UI
- **Uniform Widget Sizing**: Standardized component dimensions
- **Color Palette**: Accessible colors with light/dark mode support
- **Typography System**: Consistent font sizing and weights
- **Component Library**: Reusable UI components with proper constraints

### ✅ **Services & Infrastructure**
- **DataPersistenceService**: Placeholder for data persistence (UserDefaults/Core Data)
- **HealthKitService**: Placeholder for Apple HealthKit integration
- **Error Handling**: Comprehensive error management and user feedback

### ✅ **UI Foundation**
- **Tab Navigation**: Main app structure with 5 core tabs
- **Loading States**: Proper loading and error handling
- **Onboarding Flow**: Welcome screen and user setup
- **Responsive Design**: Adaptive layouts for different screen sizes

## 🚀 Next Steps

### **Phase 2: User Profile & Onboarding (Weeks 3-4)**
- [ ] Build onboarding wizard with step-by-step flow
- [ ] Implement profile input forms (height, weight, activity level)
- [ ] Add goal selection interface (fat loss, muscle gain, health)
- [ ] Create dietary restrictions and cuisine preferences
- [ ] Implement Apple HealthKit integration for bio data

### **Phase 3: Meal Planning Engine (Weeks 5-7)**
- [ ] Build macro calculation engine based on user goals
- [ ] Create weekly meal plan structure (7 days, 3-5 meals/day)
- [ ] Implement recipe recommendation algorithm
- [ ] Add meal timing and portion size calculations

## 🛠️ Technical Implementation

### **Architecture Pattern**
```
User Input → ViewModels → Business Logic → Data Layer → Core Data
    ↓
UI Updates ← State Changes ← ObservableObject ← @Published Properties
```

### **Folder Structure**
```
nutriplanr/
├── Models/
│   ├── User.swift
│   ├── MealPlan.swift
│   ├── Recipe.swift
│   └── NutritionalGoal.swift
├── ViewModels/
│   └── AppStateManager.swift
├── Views/
│   └── ContentView.swift
├── Services/
│   ├── DataPersistenceService.swift
│   └── HealthKitService.swift
├── Utilities/
│   └── DesignSystem.swift
└── Assets.xcassets/
    ├── PrimaryColor.colorset/
    ├── BackgroundColor.colorset/
    ├── TextColor.colorset/
    └── TextSecondaryColor.colorset/
```

### **Key Features Implemented**
- **Clean Spacing**: 8pt grid system with consistent margins and padding
- **Uniform Widgets**: Standardized button heights, input fields, and card dimensions
- **State Management**: Proper MVVM with ObservableObject and Combine
- **Modular Design**: Separated concerns with reusable components
- **Best Practices**: SwiftUI best practices with proper error handling

## 🎨 Design System

### **Spacing Constants**
```swift
struct Spacing {
    static let xs: CGFloat = 4   // 0.5x grid
    static let sm: CGFloat = 8   // 1x grid
    static let md: CGFloat = 16  // 2x grid
    static let lg: CGFloat = 24  // 3x grid
    static let xl: CGFloat = 32  // 4x grid
    static let xxl: CGFloat = 48 // 6x grid
}
```

### **Component Sizing**
```swift
struct ComponentSize {
    static let buttonHeight: CGFloat = 44
    static let inputFieldHeight: CGFloat = 48
    static let cardCornerRadius: CGFloat = 12
    static let mealCardHeight: CGFloat = 120
}
```

### **Color Palette**
- **Primary**: Green-based color for main actions
- **Background**: Light gray for app background
- **Text**: Dark gray for primary text
- **Text Secondary**: Medium gray for secondary text

## 📱 Current App Structure

The app currently shows:
1. **Loading Screen**: While initializing data
2. **Onboarding**: Welcome screen for new users
3. **Main App**: Tab-based navigation with placeholder content

## 🔧 Development Setup

### **Requirements**
- Xcode 16.4+
- iOS 18.5+
- Swift 5.0+

### **Building the App**
1. Open `nutriplanr.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project

### **Current Features**
- ✅ App launches and shows onboarding
- ✅ Tab navigation structure
- ✅ Placeholder views for all main sections
- ✅ Design system with consistent spacing
- ✅ State management foundation

## 📋 Development Checklist

### **Phase 1 - Foundation ✅**
- [x] Project structure and folder organization
- [x] Core data models (User, Recipe, MealPlan, NutritionalGoal)
- [x] MVVM architecture with AppStateManager
- [x] Design system (spacing, sizing, colors, typography)
- [x] Basic UI foundation with tab navigation
- [x] Placeholder services (DataPersistence, HealthKit)

### **Phase 2 - User Profile & Onboarding**
- [ ] Onboarding wizard implementation
- [ ] Profile input forms
- [ ] Goal selection interface
- [ ] HealthKit integration
- [ ] Data persistence implementation

### **Phase 3 - Meal Planning Engine**
- [ ] Macro calculation engine
- [ ] Meal plan generation
- [ ] Recipe recommendation system
- [ ] Plan customization interface

## 🤝 Contributing

This is a development project following the Meal Plan Assistant PRD. The app is built with a focus on:
- **Clean, even spacing** throughout the UI
- **Uniform, consistent widget sizing**
- **Proper state management and initialization**
- **Simple, scalable, and modular architecture**
- **Best practices for iOS development and UI/UX**

## 📄 License

This project is part of the Meal Plan Assistant development initiative.



