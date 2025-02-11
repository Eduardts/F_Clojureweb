struct HealthDataView: View {
    let data: HealthData?
    
    var body: some View {
        VStack(spacing: 20) {
            MetricCard(
                title: "Heart Rate",
                value: "$data?.heartRate ?? 0) BPM"
            )
            MetricCard(
                title: "Blood Pressure",
                value: "$data?.bloodPressure.systolic ?? 0)/$data?.bloodPressure.diastolic ?? 0)"
            )
            MetricCard(
                title: "Oxygen Saturation",
                value: "$data?.oxygenSaturation ?? 0)%"
            )
        }
        .padding()
    }
}
