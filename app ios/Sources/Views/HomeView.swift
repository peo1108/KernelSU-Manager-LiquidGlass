import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Working Status Card
                    HStack(spacing: 12) {
                        // Checkmark card
                        ZStack(alignment: .bottomTrailing) {
                            Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.1)
                                .cornerRadius(16)
                            
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.8))
                                .offset(x: 20, y: 30)
                            
                            VStack(alignment: .leading) {
                                Text("Working")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Version 12345")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .clipped()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Right column: Superuser & Modules basic stats
                        VStack(spacing: 12) {
                            statCard(title: "Superuser", count: "8")
                            statCard(title: "Module", count: "14")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 160)
                    
                    // Device Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        infoRow(title: "Kernel", value: "iOS 26.4.0-troll")
                        infoRow(title: "Manager version", value: "1.0.0 (10000)")
                        infoRow(title: "SELinux", value: "Permissive")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("KernelSU")
        }
    }
    
    private func statCard(title: String, count: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(count)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
