@MainActor
class HealthMonitorViewModel: ObservableObject {
    @Published var healthData: HealthData?
    @Published var anomalies: [Anomaly] = []
    @Published var isAuthenticated = false
    
    private let api = HealthMonitorAPI()
    private let biometricAuth = BiometricAuthService()
    
    func authenticate() async {
        do {
            let biometricSuccess = try await biometricAuth.authenticateUser()
            if biometricSuccess {
                let biometricData = try await biometricAuth.collectBiometricData()
                let token = try await api.authenticate(biometricData: biometricData)
                isAuthenticated = true
            }
        } catch {
            // Handle authentication error
        }
    }
    
    func startHealthMonitoring() {
        // Start collecting health data from HealthKit
        Task {
            for await data in HealthKitManager.shared.healthDataStream {
                healthData = data
                let newAnomalies = try await api.sendHealthData(data)
                anomalies = newAnomalies
            }
        }
    }
}
