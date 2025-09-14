import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    
    // Basic Information
    var name: String
    var description: String
    var cuisineType: CuisineType
    var dietaryTags: Set<DietaryRestriction>
    var difficulty: Difficulty
    var prepTime: Int // in minutes
    var cookTime: Int // in minutes
    var servings: Int
    
    // Nutritional Information (per serving)
    var calories: Double
    var protein: Double // in grams
    var carbohydrates: Double // in grams
    var fat: Double // in grams
    
    init(name: String, description: String, cuisineType: CuisineType, dietaryTags: Set<DietaryRestriction>, difficulty: Difficulty, prepTime: Int, cookTime: Int, servings: Int, calories: Double, protein: Double, carbohydrates: Double, fat: Double, fiber: Double, sugar: Double, sodium: Double, ingredients: [RecipeIngredient], instructions: [String], imageURL: String? = nil, tags: Set<String>, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.cuisineType = cuisineType
        self.dietaryTags = dietaryTags
        self.difficulty = difficulty
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageURL = imageURL
        self.tags = tags
        self.isFavorite = isFavorite
    }
    var fiber: Double // in grams
    var sugar: Double // in grams
    var sodium: Double // in milligrams
    
    // Ingredients
    var ingredients: [RecipeIngredient]
    
    // Instructions
    var instructions: [String]
    
    // Additional Information
    var imageURL: String?
    var tags: Set<String>
    var isFavorite: Bool = false
    var lastCooked: Date?
    
    // Computed Properties
    var totalTime: Int {
        return prepTime + cookTime
    }
    
    var totalCalories: Double {
        return calories * Double(servings)
    }
    
    var totalProtein: Double {
        return protein * Double(servings)
    }
    
    var totalCarbohydrates: Double {
        return carbohydrates * Double(servings)
    }
    
    var totalFat: Double {
        return fat * Double(servings)
    }
    
    // Initialization
    init(name: String, description: String, cuisineType: CuisineType, 
         dietaryTags: Set<DietaryRestriction>, difficulty: Difficulty,
         prepTime: Int, cookTime: Int, servings: Int, calories: Double,
         protein: Double, carbohydrates: Double, fat: Double, fiber: Double,
         sugar: Double, sodium: Double, ingredients: [RecipeIngredient],
         instructions: [String], imageURL: String? = nil, tags: Set<String> = []) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.cuisineType = cuisineType
        self.dietaryTags = dietaryTags
        self.difficulty = difficulty
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageURL = imageURL
        self.tags = tags
        self.isFavorite = false
        self.lastCooked = nil
    }
}

// MARK: - Supporting Types
struct RecipeIngredient: Identifiable, Codable {
    let id: UUID
    var ingredient: Ingredient
    var quantity: Double
    var unit: MeasurementUnit
    var notes: String?
    
    init(ingredient: Ingredient, quantity: Double, unit: MeasurementUnit, notes: String? = nil) {
        self.id = UUID()
        self.ingredient = ingredient
        self.quantity = quantity
        self.unit = unit
        self.notes = notes
    }
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: IngredientCategory
    var nutritionalInfo: NutritionalInfo
    var isAllergen: Bool
    var tags: Set<String>
    
    init(name: String, category: IngredientCategory, nutritionalInfo: NutritionalInfo, isAllergen: Bool = false, tags: Set<String> = []) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.nutritionalInfo = nutritionalInfo
        self.isAllergen = isAllergen
        self.tags = tags
    }
}

struct NutritionalInfo: Codable {
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbohydratesPer100g: Double
    var fatPer100g: Double
    var fiberPer100g: Double
    var sugarPer100g: Double
    var sodiumPer100g: Double
    
    init(caloriesPer100g: Double, proteinPer100g: Double, carbohydratesPer100g: Double,
         fatPer100g: Double, fiberPer100g: Double, sugarPer100g: Double, sodiumPer100g: Double) {
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbohydratesPer100g = carbohydratesPer100g
        self.fatPer100g = fatPer100g
        self.fiberPer100g = fiberPer100g
        self.sugarPer100g = sugarPer100g
        self.sodiumPer100g = sodiumPer100g
    }
}

enum IngredientCategory: String, CaseIterable, Codable {
    case produce = "produce"
    case protein = "protein"
    case dairy = "dairy"
    case grains = "grains"
    case spices = "spices"
    case oils = "oils"
    case nuts = "nuts"
    case legumes = "legumes"
    case condiments = "condiments"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .produce: return "Produce"
        case .protein: return "Protein"
        case .dairy: return "Dairy"
        case .grains: return "Grains"
        case .spices: return "Spices"
        case .oils: return "Oils"
        case .nuts: return "Nuts"
        case .legumes: return "Legumes"
        case .condiments: return "Condiments"
        case .other: return "Other"
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Codable {
    case grams = "g"
    case kilograms = "kg"
    case milliliters = "ml"
    case liters = "l"
    case cups = "cups"
    case tablespoons = "tbsp"
    case teaspoons = "tsp"
    case ounces = "oz"
    case pounds = "lbs"
    case pieces = "pieces"
    case slices = "slices"
    
    var displayName: String {
        switch self {
        case .grams: return "grams"
        case .kilograms: return "kg"
        case .milliliters: return "ml"
        case .liters: return "l"
        case .cups: return "cups"
        case .tablespoons: return "tbsp"
        case .teaspoons: return "tsp"
        case .ounces: return "oz"
        case .pounds: return "lbs"
        case .pieces: return "pieces"
        case .slices: return "slices"
        }
    }
    
    var isMetric: Bool {
        switch self {
        case .grams, .kilograms, .milliliters, .liters:
            return true
        default:
            return false
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }
}


