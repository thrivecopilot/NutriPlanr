import Foundation
import HealthKit

struct User: Identifiable, Codable {
    var id: UUID
    
    // Basic Information
    var height: Double // in inches
    var weight: Double // in pounds
    var age: Int
    var gender: Gender
    var activityLevel: ActivityLevel
    
    // Goals
    var primaryGoal: PrimaryGoal
    var goalIntensity: GoalIntensity
    var targetWeight: Double? // in pounds
    var healthImprovementGoals: Set<HealthImprovementGoal>
    
    // Dietary Preferences
    var dietaryRestrictions: Set<DietaryRestriction>
    var cuisinePreferences: Set<CuisineType>
    var weeklyBudget: Double
    var mealTiming: MealTiming
    
    // Health Data
    var healthKitData: HealthKitData?
    
    // Computed Properties
    var heightInFeetAndInches: String {
        let feet = Int(height / 12)
        let inches = Int(height.truncatingRemainder(dividingBy: 12))
        return "\(feet)'\(inches)\""
    }
    
    var weightInPounds: String {
        return "\(Int(weight)) lbs"
    }
    
    var targetWeightInPounds: String? {
        guard let target = targetWeight else { return nil }
        return "\(Int(target)) lbs"
    }
    
    var bmi: Double {
        let heightInMeters = height * 0.0254 // Convert inches to meters
        let weightInKg = weight * 0.453592 // Convert pounds to kg
        return weightInKg / (heightInMeters * heightInMeters)
    }
    
    var maintenanceCalories: Double {
        // Mifflin-St Jeor Equation (using inches and pounds)
        let heightInCm = height * 2.54
        let weightInKg = weight * 0.453592
        
        let bmr: Double
        switch gender {
        case .male:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) + 5
        case .female:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) - 161
        case .other:
            // Use average of male and female calculations
            let maleBMR = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) + 5
            let femaleBMR = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) - 161
            bmr = (maleBMR + femaleBMR) / 2
        }
        
        return bmr * activityLevel.multiplier
    }
    
    var targetCalories: Double {
        switch primaryGoal {
        case .loseWeight:
            let deficit = goalIntensity.calorieDeficit
            return maintenanceCalories - deficit
        case .gainWeight:
            let surplus = goalIntensity.calorieSurplus
            return maintenanceCalories + surplus
        case .maintain, .improveHealth:
            return maintenanceCalories
        }
    }
    
    // Initialization
    init(height: Double = 72.0, weight: Double = 180.0, age: Int = 30, gender: Gender = .other, 
         activityLevel: ActivityLevel = .moderate, primaryGoal: PrimaryGoal = .maintain, 
         goalIntensity: GoalIntensity = .moderate, targetWeight: Double? = nil,
         dietaryRestrictions: Set<DietaryRestriction> = [],
         cuisinePreferences: Set<CuisineType> = [], weeklyBudget: Double = 100.0,
         mealTiming: MealTiming = MealTiming(), healthImprovementGoals: Set<HealthImprovementGoal> = []) {
        self.id = UUID()
        self.height = height
        self.weight = weight
        self.age = age
        self.gender = gender
        self.activityLevel = activityLevel
        self.primaryGoal = primaryGoal
        self.goalIntensity = goalIntensity
        self.targetWeight = targetWeight
        self.dietaryRestrictions = dietaryRestrictions
        self.cuisinePreferences = cuisinePreferences
        self.weeklyBudget = weeklyBudget
        self.mealTiming = mealTiming
        self.healthImprovementGoals = healthImprovementGoals
    }
}

// MARK: - Enums
enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .other: return "Other"
        }
    }
}

enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderate = "moderate"
    case veryActive = "very_active"
    case extremelyActive = "extremely_active"
    
    var displayName: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Lightly Active"
        case .moderate: return "Moderate"
        case .veryActive: return "Very Active"
        case .extremelyActive: return "Extremely Active"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderate: return 1.55
        case .veryActive: return 1.725
        case .extremelyActive: return 1.9
        }
    }
}

enum PrimaryGoal: String, CaseIterable, Codable {
    case loseWeight = "lose_weight"
    case gainWeight = "gain_weight"
    case maintain = "maintain"
    case improveHealth = "improve_health"
    
    var displayName: String {
        switch self {
        case .loseWeight: return "Lose Weight"
        case .gainWeight: return "Gain Weight"
        case .maintain: return "Maintain Weight"
        case .improveHealth: return "Improve Health"
        }
    }
    
    var icon: String {
        switch self {
        case .loseWeight: return "arrow.down.circle"
        case .gainWeight: return "arrow.up.circle"
        case .maintain: return "equal.circle"
        case .improveHealth: return "heart"
        }
    }
    
    var description: String {
        switch self {
        case .loseWeight: return "Reduce body fat while preserving muscle mass"
        case .gainWeight: return "Increase muscle mass and weight"
        case .maintain: return "Keep your current weight and body composition"
        case .improveHealth: return "Focus on overall health and wellness"
        }
    }
}

enum GoalIntensity: String, CaseIterable, Codable {
    case slow = "slow"
    case moderate = "moderate"
    case aggressive = "aggressive"
    
    var displayName: String {
        switch self {
        case .slow: return "Slow & Steady"
        case .moderate: return "Moderate"
        case .aggressive: return "Aggressive"
        }
    }
    
    var calorieDeficit: Double {
        switch self {
        case .slow: return 250
        case .moderate: return 500
        case .aggressive: return 750
        }
    }
    
    var calorieSurplus: Double {
        switch self {
        case .slow: return 200
        case .moderate: return 400
        case .aggressive: return 600
        }
    }
}

enum DietaryRestriction: String, CaseIterable, Codable {
    case vegan = "vegan"
    case vegetarian = "vegetarian"
    case glutenFree = "gluten_free"
    case dairyFree = "dairy_free"
    case nutFree = "nut_free"
    case halal = "halal"
    case kosher = "kosher"
    case lowCarb = "low_carb"
    case lowFat = "low_fat"
    case lowSodium = "low_sodium"
    
    var displayName: String {
        switch self {
        case .vegan: return "Vegan"
        case .vegetarian: return "Vegetarian"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        case .halal: return "Halal"
        case .kosher: return "Kosher"
        case .lowCarb: return "Low-Carb"
        case .lowFat: return "Low-Fat"
        case .lowSodium: return "Low-Sodium"
        }
    }
}

enum CuisineType: String, CaseIterable, Codable {
    case american = "american"
    case mediterranean = "mediterranean"
    case mexican = "mexican"
    case italian = "italian"
    case asian = "asian"
    case indian = "indian"
    case middleEastern = "middle_eastern"
    case african = "african"
    case european = "european"
    case latinAmerican = "latin_american"
    
    var displayName: String {
        switch self {
        case .american: return "American"
        case .mediterranean: return "Mediterranean"
        case .mexican: return "Mexican"
        case .italian: return "Italian"
        case .asian: return "Asian"
        case .indian: return "Indian"
        case .middleEastern: return "Middle Eastern"
        case .african: return "African"
        case .european: return "European"
        case .latinAmerican: return "Latin American"
        }
    }
}

struct MealTiming: Codable {
    var intermittentFasting: Bool = false
    var fastingStartTime: Date = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    var fastingEndTime: Date = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    var noFoodAfter: Date = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    
    // Meal inclusion flags
    var includeBreakfast: Bool = true
    var includeLunch: Bool = true
    var includeDinner: Bool = true
    var includeSnacks: Bool = true
    
    // Meal timing
    var breakfastTime: Date = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    var lunchTime: Date = Calendar.current.date(from: DateComponents(hour: 12, minute: 0)) ?? Date()
    var dinnerTime: Date = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
    var snackTime: Date = Calendar.current.date(from: DateComponents(hour: 15, minute: 0)) ?? Date()
    
    init() {}
    
    init(intermittentFasting: Bool, fastingStartTime: Date, fastingEndTime: Date, noFoodAfter: Date) {
        self.intermittentFasting = intermittentFasting
        self.fastingStartTime = fastingStartTime
        self.fastingEndTime = fastingEndTime
        self.noFoodAfter = noFoodAfter
    }
}

struct HealthKitData: Codable {
    var lastSyncDate: Date
    var height: Double?
    var weight: Double?
    var age: Int?
    var gender: Gender?
    var activityLevel: ActivityLevel?
    
    init(lastSyncDate: Date = Date()) {
        self.lastSyncDate = lastSyncDate
    }
}

// MARK: - Health Improvement Goals
enum HealthImprovementGoal: String, CaseIterable, Codable {
    case energyLevels = "energy_levels"
    case bloodLipids = "blood_lipids"
    case sleepQuality = "sleep_quality"
    case mealTiming = "meal_timing"
    case bloodSugar = "blood_sugar"
    case inflammation = "inflammation"
    case digestion = "digestion"
    case mentalClarity = "mental_clarity"
    
    var displayName: String {
        switch self {
        case .energyLevels: return "Energy Levels"
        case .bloodLipids: return "Blood Lipids"
        case .sleepQuality: return "Sleep Quality"
        case .mealTiming: return "Meal Timing"
        case .bloodSugar: return "Blood Sugar Control"
        case .inflammation: return "Reduce Inflammation"
        case .digestion: return "Digestive Health"
        case .mentalClarity: return "Mental Clarity"
        }
    }
    
    var icon: String {
        switch self {
        case .energyLevels: return "bolt.circle"
        case .bloodLipids: return "heart.circle"
        case .sleepQuality: return "moon.circle"
        case .mealTiming: return "clock.circle"
        case .bloodSugar: return "drop.circle"
        case .inflammation: return "flame.circle"
        case .digestion: return "leaf.circle"
        case .mentalClarity: return "brain.head.profile"
        }
    }
    
    var description: String {
        switch self {
        case .energyLevels: return "Optimize energy throughout the day"
        case .bloodLipids: return "Improve cholesterol and heart health"
        case .sleepQuality: return "Better sleep through nutrition"
        case .mealTiming: return "Optimize when you eat"
        case .bloodSugar: return "Stable blood sugar levels"
        case .inflammation: return "Reduce chronic inflammation"
        case .digestion: return "Improve gut health and digestion"
        case .mentalClarity: return "Enhance focus and cognitive function"
        }
    }
}
