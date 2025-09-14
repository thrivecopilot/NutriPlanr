import SwiftUI

struct MealTimingStepView: View {
    @Binding var userProfile: UserProfile
    @State private var selectedFastingType: FastingType? = nil
    @State private var feedingWindowStart: Double = 8.0 // 8 AM
    @State private var feedingWindowLength: Double = 8.0 // 8 hours
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Meal Timing")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Set your preferred eating schedule and meal times")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Intermittent Fasting Options
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Intermittent Fasting")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    Text("Choose a fasting pattern to automatically set meal times")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)
                    
                    VStack(spacing: Spacing.sm) {
                        ForEach(FastingType.allCases, id: \.self) { fastingType in
                            FastingOptionView(
                                fastingType: fastingType,
                                isSelected: selectedFastingType == fastingType,
                                onSelect: { 
                                    selectedFastingType = fastingType
                                    applyFastingSchedule(fastingType)
                                }
                            )
                        }
                    }
                }
                
                // Visual Timeline Slider (only show if a fasting type is selected)
                if selectedFastingType != nil && selectedFastingType != .custom {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Adjust Feeding Window")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        TimelineSliderView(
                            feedingWindowStart: $feedingWindowStart,
                            feedingWindowLength: $feedingWindowLength,
                            onWindowChanged: { start, length in
                                updateMealTimesFromWindow(start: start, length: length)
                            }
                        )
                    }
                }
                
                // Custom Meal Times (only show if Custom is selected)
                if selectedFastingType == .custom {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("Custom Meal Times")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        VStack(spacing: Spacing.md) {
                            MealTimeRow(
                                title: "Breakfast",
                                time: $userProfile.mealTiming.breakfastTime,
                                icon: "sunrise"
                            )
                            
                            MealTimeRow(
                                title: "Lunch",
                                time: $userProfile.mealTiming.lunchTime,
                                icon: "sun.max"
                            )
                            
                            MealTimeRow(
                                title: "Dinner",
                                time: $userProfile.mealTiming.dinnerTime,
                                icon: "sunset"
                            )
                            
                            MealTimeRow(
                                title: "Snacks",
                                time: $userProfile.mealTiming.snackTime,
                                icon: "leaf"
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func applyFastingSchedule(_ fastingType: FastingType) {
        let calendar = Calendar.current
        let today = Date()
        
        switch fastingType {
        case .sixteenEight:
            // 16:8 - Eat from 12pm to 8pm
            feedingWindowStart = 12.0
            feedingWindowLength = 8.0
            userProfile.mealTiming.breakfastTime = calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? today
            userProfile.mealTiming.lunchTime = calendar.date(from: DateComponents(hour: 15, minute: 0)) ?? today
            userProfile.mealTiming.dinnerTime = calendar.date(from: DateComponents(hour: 19, minute: 0)) ?? today
            userProfile.mealTiming.snackTime = calendar.date(from: DateComponents(hour: 16, minute: 30)) ?? today
        case .fourteenTen:
            // 14:10 - Eat from 8am to 6pm
            feedingWindowStart = 8.0
            feedingWindowLength = 10.0
            userProfile.mealTiming.breakfastTime = calendar.date(from: DateComponents(hour: 8, minute: 0)) ?? today
            userProfile.mealTiming.lunchTime = calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? today
            userProfile.mealTiming.dinnerTime = calendar.date(from: DateComponents(hour: 17, minute: 0)) ?? today
            userProfile.mealTiming.snackTime = calendar.date(from: DateComponents(hour: 14, minute: 30)) ?? today
        case .twelveTwelve:
            // 12:12 - Eat from 7am to 7pm
            feedingWindowStart = 7.0
            feedingWindowLength = 12.0
            userProfile.mealTiming.breakfastTime = calendar.date(from: DateComponents(hour: 7, minute: 0)) ?? today
            userProfile.mealTiming.lunchTime = calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? today
            userProfile.mealTiming.dinnerTime = calendar.date(from: DateComponents(hour: 18, minute: 0)) ?? today
            userProfile.mealTiming.snackTime = calendar.date(from: DateComponents(hour: 15, minute: 0)) ?? today
        case .omad:
            // OMAD - One meal at 2pm
            feedingWindowStart = 14.0
            feedingWindowLength = 1.0
            userProfile.mealTiming.breakfastTime = calendar.date(from: DateComponents(hour: 14, minute: 0)) ?? today
            userProfile.mealTiming.lunchTime = calendar.date(from: DateComponents(hour: 14, minute: 0)) ?? today
            userProfile.mealTiming.dinnerTime = calendar.date(from: DateComponents(hour: 14, minute: 0)) ?? today
            userProfile.mealTiming.snackTime = calendar.date(from: DateComponents(hour: 14, minute: 0)) ?? today
        case .custom:
            // Custom - don't change times
            break
        }
    }
    
    private func updateMealTimesFromWindow(start: Double, length: Double) {
        let calendar = Calendar.current
        let today = Date()
        
        // Ensure valid values
        let safeStart = max(0, min(23, start))
        let safeLength = max(1, min(12, length))
        
        // Calculate meal times within the feeding window
        let breakfastHour = Int(safeStart)
        let lunchHour = Int(safeStart + safeLength * 0.4)
        let dinnerHour = Int(safeStart + safeLength * 0.8)
        let snackHour = Int(safeStart + safeLength * 0.6)
        
        // Ensure hours are within valid range
        let safeBreakfastHour = max(0, min(23, breakfastHour))
        let safeLunchHour = max(0, min(23, lunchHour))
        let safeDinnerHour = max(0, min(23, dinnerHour))
        let safeSnackHour = max(0, min(23, snackHour))
        
        userProfile.mealTiming.breakfastTime = calendar.date(from: DateComponents(hour: safeBreakfastHour, minute: 0)) ?? today
        userProfile.mealTiming.lunchTime = calendar.date(from: DateComponents(hour: safeLunchHour, minute: 0)) ?? today
        userProfile.mealTiming.dinnerTime = calendar.date(from: DateComponents(hour: safeDinnerHour, minute: 0)) ?? today
        userProfile.mealTiming.snackTime = calendar.date(from: DateComponents(hour: safeSnackHour, minute: 0)) ?? today
    }
}

enum FastingType: String, CaseIterable {
    case sixteenEight = "16:8"
    case fourteenTen = "14:10"
    case twelveTwelve = "12:12"
    case omad = "OMAD"
    case custom = "Custom"
    
    var displayName: String {
        switch self {
        case .sixteenEight: return "16:8 Fasting"
        case .fourteenTen: return "14:10 Fasting"
        case .twelveTwelve: return "12:12 Fasting"
        case .omad: return "OMAD (One Meal)"
        case .custom: return "Custom Schedule"
        }
    }
    
    var description: String {
        switch self {
        case .sixteenEight: return "Fast 16 hours, eat 8 hours (12pm-8pm)"
        case .fourteenTen: return "Fast 14 hours, eat 10 hours (8am-6pm)"
        case .twelveTwelve: return "Fast 12 hours, eat 12 hours (7am-7pm)"
        case .omad: return "One meal per day (2pm)"
        case .custom: return "Set your own meal times"
        }
    }
    
    var icon: String {
        switch self {
        case .sixteenEight: return "clock"
        case .fourteenTen: return "clock.fill"
        case .twelveTwelve: return "clock.badge"
        case .omad: return "1.circle"
        case .custom: return "slider.horizontal.3"
        }
    }
}

struct FastingOptionView: View {
    let fastingType: FastingType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Spacing.md) {
                Image(systemName: fastingType.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : AppColors.forestGreen)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(fastingType.displayName)
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(isSelected ? .white : AppColors.text)
                    
                    Text(fastingType.description)
                        .font(AppTypography.caption())
                        .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .padding(Spacing.md)
            .background(isSelected ? AppColors.forestGreen : AppColors.background)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(AppColors.forestGreen.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MealTimeRow: View {
    let title: String
    @Binding var time: Date
    let icon: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColors.forestGreen)
                .frame(width: 24)
            
            Text(title)
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Text(timeString)
                .font(AppTypography.body())
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(AppColors.background)
                .cornerRadius(CornerRadius.small)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(AppColors.forestGreen.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
    }
}

struct TimelineSliderView: View {
    @Binding var feedingWindowStart: Double
    @Binding var feedingWindowLength: Double
    let onWindowChanged: (Double, Double) -> Void
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            // 24-hour timeline
            ZStack(alignment: .leading) {
                // Background timeline
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.background)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                    )
                
                // Hour markers
                HStack(spacing: 0) {
                    ForEach(0..<24, id: \.self) { hour in
                        Rectangle()
                            .fill(AppColors.textSecondary.opacity(0.3))
                            .frame(width: 1, height: 20)
                            .offset(y: 10)
                        
                        if hour < 23 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                // Feeding window - single connected rectangle
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColors.forestGreen.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AppColors.forestGreen, lineWidth: 2)
                    )
                    .frame(width: feedingWindowLength * 12, height: 32) // 12 points per hour
                    .offset(x: feedingWindowStart * 12 + 4, y: 4)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Round to 10-minute increments (1/6 hour)
                                let rawPosition = Double(value.location.x - 4) / 12.0
                                let roundedPosition = round(rawPosition * 6) / 6 // Round to nearest 10 minutes
                                let newStart = max(0, min(24 - feedingWindowLength, roundedPosition))
                                if newStart != feedingWindowStart {
                                    feedingWindowStart = newStart
                                    onWindowChanged(newStart, feedingWindowLength)
                                }
                            }
                    )
            }
            
            // Controls
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("Start Time")
                        .font(AppTypography.caption(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                    
                    Text(timeString(from: feedingWindowStart))
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                HStack {
                    Text("Window Length")
                        .font(AppTypography.caption(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                    
                    Text("\(Int(feedingWindowLength)) hours")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Slider(value: $feedingWindowLength, in: 1...12, step: 1)
                    .accentColor(AppColors.forestGreen)
                    .onChange(of: feedingWindowLength) { newValue in
                        // Ensure window doesn't go past 24 hours
                        if feedingWindowStart + newValue > 24 {
                            feedingWindowStart = 24 - newValue
                        }
                        onWindowChanged(feedingWindowStart, newValue)
                    }
            }
        }
        .padding(Spacing.md)
        .background(AppColors.forestGreen.opacity(0.05))
        .cornerRadius(CornerRadius.medium)
    }
    
    private func timeString(from hour: Double) -> String {
        let hourInt = Int(hour)
        let minute = Int((hour - Double(hourInt)) * 60)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let date = Calendar.current.date(from: DateComponents(hour: hourInt, minute: minute)) ?? Date()
        return formatter.string(from: date)
    }
}

#Preview {
    MealTimingStepView(userProfile: .constant(UserProfile()))
}
