import SwiftUI

struct BasicInfoStepView: View {
    @Binding var userProfile: UserProfile
    @State private var feetString: String = "6"
    @State private var inchesString: String = "0"
    @State private var weightString: String = "180"
    @State private var ageString: String = "30"
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Basic Information")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Help us understand your current situation to provide personalized recommendations")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Form fields
                VStack(spacing: Spacing.lg) {
                    // Height
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Height")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        HStack(spacing: Spacing.sm) {
                            TextField("Feet", text: $feetString)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                                .onChange(of: feetString) { newValue in
                                    updateHeight()
                                }
                            
                            Text("ft")
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textSecondary)
                            
                            TextField("Inches", text: $inchesString)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                                .onChange(of: inchesString) { newValue in
                                    updateHeight()
                                }
                            
                            Text("in")
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    // Weight
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Weight")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        HStack {
                            TextField("Weight", text: $weightString)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: weightString) { newValue in
                                    if let weight = Double(newValue) {
                                        userProfile.weight = weight
                                    }
                                }
                            
                            Text("lbs")
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    // Age
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Age")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        TextField("Age", text: $ageString)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: ageString) { newValue in
                                if let age = Int(newValue) {
                                    userProfile.age = age
                                }
                            }
                    }
                    
                    // Gender
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Gender")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        Picker("Gender", selection: $userProfile.gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.displayName).tag(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Activity Level - Use MenuPickerStyle to avoid text cutoff
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Activity Level")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        Menu {
                            Picker("Activity Level", selection: $userProfile.activityLevel) {
                                ForEach(ActivityLevel.allCases, id: \.self) { level in
                                    Text(level.displayName).tag(level)
                                }
                            }
                        } label: {
                            HStack {
                                Text(userProfile.activityLevel.displayName)
                                    .foregroundColor(AppColors.text)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(Spacing.sm)
                            .background(AppColors.background)
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                
                // BMI calculation preview
                if userProfile.hasBasicInfo {
                    BMIPreviewView(userProfile: userProfile)
                }
            }
        }
        .onAppear {
            // Initialize with current values
            let feet = Int(userProfile.height / 12)
            let inches = Int(userProfile.height.truncatingRemainder(dividingBy: 12))
            feetString = String(feet)
            inchesString = String(inches)
            weightString = String(Int(userProfile.weight))
            ageString = String(userProfile.age)
        }
    }
    
    private func updateHeight() {
        if let feet = Int(feetString), let inches = Double(inchesString) {
            userProfile.height = Double(feet) * 12 + inches
        }
    }
}

struct BMIPreviewView: View {
    let userProfile: UserProfile
    
    private var bmi: Double {
        let heightInMeters = userProfile.height * 0.0254 // Convert inches to meters
        let weightInKg = userProfile.weight * 0.453592 // Convert pounds to kg
        return weightInKg / (heightInMeters * heightInMeters)
    }
    
    private var bmiCategory: String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal weight"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
    
    private var bmiColor: Color {
        switch bmi {
        case ..<18.5: return .orange
        case 18.5..<25: return .green
        case 25..<30: return .orange
        default: return .red
        }
    }
    
    private var heightDisplay: String {
        let feet = Int(userProfile.height / 12)
        let inches = Int(userProfile.height.truncatingRemainder(dividingBy: 12))
        return "\(feet)'\(inches)\""
    }
    
    private var weightDisplay: String {
        return "\(Int(userProfile.weight)) lbs"
    }
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Your BMI")
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.text)
            
            HStack(spacing: Spacing.lg) {
                VStack {
                    Text(String(format: "%.1f", bmi))
                        .font(AppTypography.display())
                        .foregroundColor(bmiColor)
                    
                    Text(bmiCategory)
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Height: \(heightDisplay)")
                    Text("Weight: \(weightDisplay)")
                    Text("Age: \(userProfile.age) years")
                }
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(AppColors.background)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    BasicInfoStepView(userProfile: .constant(UserProfile()))
}
