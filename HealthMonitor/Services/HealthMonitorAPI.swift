class HealthMonitorAPI {
    private let baseURL = URL(string: "https://api.healthmonitor.com")!
    private var authToken: String?
    
    func authenticate(biometricData: BiometricData) async throws -> String {
        let url = baseURL.appendingPathComponent("auth/biometric")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = BiometricAuthRequest(
            userId: UserDefaults.standard.string(forKey: "userId")!,
            biometricData: biometricData
        )
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        authToken = response.token
        return response.token
    }
    
    func sendHealthData(_ data: HealthData) async throws -> [Anomaly] {
        guard let token = authToken else { throw APIError.notAuthenticated }
        
        let url = baseURL.appendingPathComponent("health/data")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer $token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(HealthDataResponse.self, from: data)
        return response.anomalies
    }
}
