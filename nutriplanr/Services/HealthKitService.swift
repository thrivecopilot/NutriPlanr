import Foundation
import HealthKit

// MARK: - HealthKit Service
class HealthKitService {
    
    private let healthStore = HKHealthStore()
    private var isAuthorized = false
    
    // MARK: - Authorization
    func checkAuthorization(completion: @escaping (Bool) -> Void) {
        guard isHealthKitAvailable() else {
            print("HealthKit not available on this device")
            completion(false)
            return
        }
        
        // Check if we have authorization for the types we need
        guard let heightType = HKObjectType.quantityType(forIdentifier: .height) else {
            print("Required HealthKit types not available")
            completion(false)
            return
        }
        
        let status = healthStore.authorizationStatus(for: heightType)
        let isAuthorized = status == .sharingAuthorized
        
        DispatchQueue.main.async {
            self.isAuthorized = isAuthorized
            completion(isAuthorized)
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard isHealthKitAvailable() else {
            print("HealthKit not available on this device")
            completion(false)
            return
        }
        
        // Define the types of data we want to read and write
        var typesToRead: Set<HKObjectType> = []
        var typesToWrite: Set<HKSampleType> = []
        
        // Safely add types with null checks
        if let heightType = HKObjectType.quantityType(forIdentifier: .height) {
            typesToRead.insert(heightType)
            typesToWrite.insert(heightType)
        }
        
        if let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            typesToRead.insert(bodyMassType)
            typesToWrite.insert(bodyMassType)
        }
        
        if let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) {
            typesToRead.insert(dateOfBirthType)
        }
        
        if let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex) {
            typesToRead.insert(biologicalSexType)
        }
        
        // Only proceed if we have types to request
        guard !typesToRead.isEmpty else {
            print("No HealthKit types available for authorization")
            completion(false)
            return
        }
        
        // Request authorization
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("HealthKit authorization error: \(error)")
                    completion(false)
                } else {
                    self.isAuthorized = success
                    completion(success)
                }
            }
        }
    }
    
    // MARK: - Data Fetching
    
    func fetchHeight(completion: @escaping (Double?) -> Void) {
        guard let heightType = HKObjectType.quantityType(forIdentifier: .height) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            
            let heightInCm = sample.quantity.doubleValue(for: HKUnit(from: .centimeter))
            let heightInInches = heightInCm / 2.54 // Convert cm to inches
            completion(heightInInches)
        }
        
        healthStore.execute(query)
    }
    
    func fetchWeight(completion: @escaping (Double?) -> Void) {
        guard let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            completion(nil)
            return
        }
        
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            let weightInPounds = weightInKg * 2.20462 // Convert kg to pounds
            completion(weightInPounds)
        }
        
        healthStore.execute(query)
    }
    
    func fetchAge(completion: @escaping (Int?) -> Void) {
        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentDate = Date()
            
            if let birthDate = calendar.date(from: dateOfBirth) {
                let age = calendar.dateComponents([.year], from: birthDate, to: currentDate).year
                completion(age)
            } else {
                completion(nil)
            }
        } catch {
            print("Error fetching age: \(error)")
            completion(nil)
        }
    }
    
    func fetchGender(completion: @escaping (Gender?) -> Void) {
        do {
            let biologicalSex = try healthStore.biologicalSex()
            let gender: Gender
            
            switch biologicalSex.biologicalSex {
            case .female:
                gender = .female
            case .male:
                gender = .male
            case .other:
                gender = .other
            case .notSet:
                gender = .other
            @unknown default:
                gender = .other
            }
            
            completion(gender)
        } catch {
            print("Error fetching gender: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - Combined Data Fetching
    
    func fetchUserData(completion: @escaping (HealthKitData) -> Void) {
        let group = DispatchGroup()
        var healthData = HealthKitData()
        
        // Fetch height
        group.enter()
        fetchHeight { height in
            healthData.height = height
            group.leave()
        }
        
        // Fetch weight
        group.enter()
        fetchWeight { weight in
            healthData.weight = weight
            group.leave()
        }
        
        // Fetch age
        group.enter()
        fetchAge { age in
            healthData.age = age
            group.leave()
        }
        
        // Fetch gender
        group.enter()
        fetchGender { gender in
            healthData.gender = gender
            group.leave()
        }
        
        // When all data is fetched, call completion
        group.notify(queue: .main) {
            completion(healthData)
        }
    }
    
    // MARK: - Health Status
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
}
