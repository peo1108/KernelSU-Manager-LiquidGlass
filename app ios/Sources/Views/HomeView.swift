import SwiftUI

// MARK: - KSU Miuix Color Constants (Dark Theme)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)          // #36D167
private let ksGreenBg = Color(red: 0.10, green: 0.22, blue: 0.15)        // #1A3825
private let ksSurface05 = Color.white.opacity(0.05)
private let ksSummary = Color.white.opacity(0.55)
private let ksOnSurface = Color.white

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // MARK: - Status Card Row (Working + Superuser/Module)
                    HStack(spacing: 12) {
                        // Left: Working Status Card
                        ZStack(alignment: .topLeading) {
                            // Green-tinted background
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ksGreenBg.opacity(0.05))
                            
                            // Large checkmark icon (offset to bottom-right, clipped)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 170, height: 170)
                                        .foregroundColor(ksGreen.opacity(0.8))
                                        .offset(x: 38, y: 45)
                                }
                            }
                            
                            // Text overlay
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Working")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(ksOnSurface)
                                Text("Version 12345")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(ksSummary)
                            }
                            .padding(16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Right: Superuser + Module count cards
                        VStack(spacing: 12) {
                            MiniStatCard(title: "Superuser", count: "8")
                            MiniStatCard(title: "Module", count: "14")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 175)
                    
                    // MARK: - Info Card
                    VStack(alignment: .leading, spacing: 0) {
                        InfoRow(title: "Kernel", value: "6.6.75-android14-11")
                        InfoRow(title: "Fingerprint", value: "K001-12345")
                        InfoRow(title: "SELinux status", value: "Enforcing")
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ksSurface05)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // MARK: - Donate Card
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Support development")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(ksOnSurface)
                            Text("If you like KernelSU, consider supporting its development")
                                .font(.system(size: 14))
                                .foregroundColor(ksSummary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ksSurface05)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // MARK: - Learn More Card
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Learn KernelSU")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(ksOnSurface)
                            Text("Click to learn more about KernelSU")
                                .font(.system(size: 14))
                                .foregroundColor(ksSummary)
                        }
                        Spacer()
                        Image(systemName: "link")
                            .foregroundColor(ksOnSurface)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ksSurface05)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Color.clear)
            .navigationTitle("KernelSU")
        }
    }
}

// MARK: - Mini Stat Card (Superuser/Module count)
private struct MiniStatCard: View {
    let title: String
    let count: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(ksSummary)
            Spacer().frame(height: 4)
            Text(count)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(ksOnSurface)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Info Row
private struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ksOnSurface)
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(ksSummary)
        }
        .padding(.vertical, 6)
    }
}
