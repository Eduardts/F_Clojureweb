struct HealthData: Codable {
    let heartRate: Double
    let bloodPressure: BloodPressure
    let oxygenSaturation: Double
    let temperature: Double
    let timestamp: Date
    
    struct BloodPressure: Codable {
        let systolic: Int
        let diastolic: Int
    }
}
