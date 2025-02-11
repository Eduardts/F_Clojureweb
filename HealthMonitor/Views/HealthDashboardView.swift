struct HealthDashboardView: View {
    @StateObject private var viewModel = HealthMonitorViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isAuthenticated {
                VStack {
                    HealthDataView(data: viewModel.healthData)
                    AnomaliesListView(anomalies: viewModel.anomalies)
                }
                .navigationTitle("Health Monitor")
            } else {
                AuthenticationView()
            }
        }
        .task {
            await viewModel.authenticate()
        }
    }
}
