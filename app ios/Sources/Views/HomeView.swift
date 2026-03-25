import SwiftUI
import UIKit

private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksGreenBg = Color(red: 0.10, green: 0.22, blue: 0.15)
private let ksSurface05 = Color.white.opacity(0.05)
private let ksSummary = Color.white.opacity(0.55)
private let ksOnSurface = Color.white
private let ksCyan = Color.cyan
private let ksRed = Color.red

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("KSU JB")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
                Image(systemName: "cpu")
                    .font(.system(size: 24))
                    .foregroundColor(ksGreen)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 4)
                    
                    // MARK: - Main Status Card
                    HStack(spacing: 12) {
                        workingCard
                        
                        VStack(spacing: 12) {
                            statCard(title: "Superuser", count: "8", icon: "shield.fill", color: ksCyan)
                            statCard(title: "Tweaks", count: "14", icon: "wrench.and.screwdriver.fill", color: .purple)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 160)
                    
                    // MARK: - System Dashboard (Apple Internal Style)
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "terminal.fill")
                                .foregroundColor(ksSummary)
                            Text("SYSTEM DIAGNOSTICS")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(ksSummary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                        VStack(spacing: 0) {
                            diagRow(title: "Device", value: "iPhone 16 Pro Max (D83AP)")
                            diagRow(title: "Darwin Kernel", value: "32.4.0 (arm64e)")
                            diagRow(title: "AMFI / SSV", value: "Patched (Active)", statusColor: ksGreen)
                            diagRow(title: "System Uptime", value: "4d 12h 03m 44s")
                            diagRow(title: "Daemon", value: "jailbreakd (PID 74)", statusColor: ksCyan)
                            diagRow(title: "Bootstrap", value: "/var/jb (Root Su)", noDivider: true)
                        }
                        .padding(.vertical, 4)
                        .background(ksSurface05)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
                    }
                    
                    // MARK: - Action Cards
                    actionCard(title: "Respring", desc: "Restart SpringBoard to apply tweaks", icon: "arrow.triangle.2.circlepath", color: ksCyan)
                    actionCard(title: "Safe Mode", desc: "Temporarily disable all tweaks", icon: "exclamationmark.triangle.fill", color: .orange)
                    actionCard(title: "Rebuild Icon Cache", desc: "Fix missing or broken icons", icon: "square.grid.2x2.fill", color: ksGreen)
                    
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 12)
            }
        }
    }
    
    private var workingCard: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(ksGreenBg.opacity(0.5))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(ksGreen.opacity(0.3), lineWidth: 1))
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Jailbroken")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(ksGreen)
                        Text("iOS 26.4 (Root Su)")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(ksGreen.opacity(0.7))
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(16)
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(ksGreen.opacity(0.4))
                .offset(x: 20, y: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func statCard(title: String, count: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ksSummary)
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(color.opacity(0.8))
            }
            Spacer().frame(height: 8)
            Text(count)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(ksOnSurface)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
    }
    
    private func diagRow(title: String, value: String, statusColor: Color? = nil, noDivider: Bool = false) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(ksOnSurface)
                Spacer()
                if let sc = statusColor {
                    Circle().fill(sc).frame(width: 6, height: 6)
                }
                Text(value)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(ksSummary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            if !noDivider {
                Rectangle()
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 0.5)
                    .padding(.leading, 16)
            }
        }
    }
    
    private func actionCard(title: String, desc: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 40, height: 40)
                Image(systemName: icon).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ksOnSurface)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(ksSummary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(ksSummary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
    }
}
