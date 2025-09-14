# NutriPlanr

A proactive nutrition planning application that focuses on planning and execution rather than reactive tracking. Built with SwiftUI for iOS.

## 🎯 Project Status

**Current Phase**: Phase 2 - User Profile & Onboarding ✅ **COMPLETED**

## 🏗️ What's Been Built

### ✅ **Complete Onboarding Flow**
- **Welcome Screen**: Choice between HealthKit sync or manual entry
- **HealthKit Integration**: Automatic data population from Apple Health
- **Basic Info Collection**: Height (feet/inches), weight (pounds), age, gender, activity level
- **Goals Selection**: Weight management and health focus areas with contextual options
- **Dietary Preferences**: Restrictions and cuisine preferences with proper sizing
- **Meal Timing**: Interactive timeline slider for intermittent fasting with 10-minute increments
- **Budget Planning**: Weekly grocery budget with guidelines
- **Summary Screen**: Complete profile overview before completion

### ✅ **Modern UI/UX Design**
- **HealthKit-First Approach**: Streamlined flow with optional manual entry
- **Interactive Timeline Slider**: Visual 24-hour feeding window adjustment
- **Conditional UI Elements**: Smart visibility based on user selections
- **US Imperial Units**: Consistent feet/inches and pounds throughout
- **Responsive Layout**: Proper text fitting and scrollable content
- **Modern Design Language**: Clean, contemporary interface

### ✅ **Technical Architecture**
- **MVVM Pattern**: Clean separation with ObservableObject and Combine
- **State Management**: Centralized AppStateManager with proper data flow
- **HealthKit Service**: Complete integration with authorization and data fetching
- **Design System**: Comprehensive spacing, colors, and typography
- **Error Handling**: Robust error management and user feedback

## 🚀 Key Features

### **Smart Onboarding Flow**
1. **Welcome**: Choose HealthKit sync or manual entry
2. **HealthKit**: Automatic population of height, weight, age, gender
3. **Basic Info**: Manual entry with feet/inches and pounds
4. **Goals**: Weight management with contextual target weight and intensity
5. **Health Focus**: Energy levels, blood lipids, sleep quality, etc.
6. **Dietary**: Restrictions and cuisine preferences
7. **Meal Timing**: Interactive fasting schedule with timeline slider
8. **Budget**: Weekly grocery budget with spending guidelines
9. **Summary**: Complete profile review

### **Interactive Meal Timing**
- **Visual Timeline**: 24-hour slider with hour markers
- **Draggable Window**: Move feeding window in 10-minute increments
- **Automatic Updates**: Meal times adjust based on window position
- **Manual Editing**: Available when "Custom" timing is selected
- **Fasting Options**: 16:8, 14:10, 12:12, OMAD, and Custom

### **HealthKit Integration**
- **Automatic Data Sync**: Height, weight, age, gender from Apple Health
- **Graceful Fallback**: Manual entry if HealthKit unavailable
- **Proper Authorization**: Complete permission handling
- **Unit Conversion**: Automatic conversion from metric to imperial

## 🛠️ Technical Implementation

### **Architecture Pattern**
```
User Input → ViewModels → Business Logic → HealthKit/Data Layer
    ↓
UI Updates ← State Changes ← ObservableObject ← @Published Properties
```

### **Key Components**
- **OnboardingFlowView**: Main orchestrator for multi-step flow
- **TimelineSliderView**: Interactive 24-hour feeding window
- **HealthKitService**: Complete Apple Health integration
- **AppStateManager**: Centralized state and navigation
- **DesignSystem**: Comprehensive styling and spacing

### **Data Models**
- **User**: Complete profile with imperial units and health goals
- **MealTiming**: Fasting schedules and meal times
- **HealthImprovementGoal**: Focus areas for nutrition planning

## 🔧 Development Setup

### **Requirements**
- Xcode 16.4+
- iOS 18.5+
- Swift 5.0+
- HealthKit capability (for full functionality)

### **Building the App**
1. Open `nutriplanr.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project
4. Grant HealthKit permissions when prompted

### **Current Features**
- ✅ Complete onboarding flow with 8 steps
- ✅ HealthKit integration with automatic data sync
- ✅ Interactive timeline slider for meal timing
- ✅ Modern, responsive UI design
- ✅ US Imperial units throughout
- ✅ Conditional UI based on user selections
- ✅ Proper error handling and validation

## 📱 App Flow

1. **Launch** → Welcome screen with HealthKit/Manual choice
2. **HealthKit** → Automatic data population (if available)
3. **Basic Info** → Height, weight, age, gender, activity level
4. **Goals** → Weight management and health focus areas
5. **Dietary** → Restrictions and cuisine preferences
6. **Meal Timing** → Interactive fasting schedule
7. **Budget** → Weekly grocery budget
8. **Summary** → Complete profile review
9. **Complete** → Ready for meal planning

## 🎨 Design System

### **Spacing & Layout**
- **8pt Grid System**: Consistent spacing throughout
- **Responsive Design**: Proper text fitting and scrolling
- **Uniform Components**: Standardized button and input sizing
- **Modern Typography**: Clean, readable font hierarchy

### **Interactive Elements**
- **Timeline Slider**: Visual 24-hour feeding window
- **Conditional UI**: Smart visibility based on selections
- **Smooth Animations**: Polished user interactions
- **Accessibility**: Proper contrast and touch targets

## 🤝 Contributing

This project follows modern iOS development best practices:
- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **HealthKit Integration**: Proper Apple Health integration
- **User Experience**: Intuitive, modern interface design
- **Code Quality**: Well-structured, maintainable code

## 📄 License

This project is part of the NutriPlanr development initiative.
