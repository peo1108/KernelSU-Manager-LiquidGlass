import SwiftUI
import UIKit

private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksRed = Color.red
private let ksYellow = Color.yellow

struct ModulesView: View {
    @State private var mods: [Bool] = [true, true, true, false, true, false, true, false, true, false]
    @State private var showConfirm = false
    @State private var pendingToggleIndex: Int? = nil
    @State private var showInstallSheet = false
    
    let moduleData = [
        ("SnowBoard", "v1.5.21-Beta3", "A lightweight spiritual successor to Winterboard", false),
        ("Cylinder Reborn", "v1.1.1", "Homescreen icon animations", false),
        ("Filza File Manager", "v4.0.1-4", "Advanced File Manager with root access", true), // Dangerous
        ("AppSync Unified", "v112.0", "Bypass iOS app signature validation", true), // Dangerous
        ("TrollStore Helper", "v2.0.15", "Helper app for permanent IPAs", false),
        ("ElleKit", "v1.1.2", "Tweak injection framework for arm64e", true), // Dangerous
        ("iCleaner Pro", "v7.10.0", "The first real iOS system cleaner", false),
        ("Snapper 3", "v1.2", "Pin screenshots on the screen", false),
        ("Atria", "v1.4.1", "Dynamic homescreen layout manager", false),
        ("Choicy", "v1.4.10-3", "Advanced Tweak Configuration", false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Tweaks")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
                Button(action: { showInstallSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ksGreen)
                        .padding(8)
                        .background(ksGreen.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<10, id: \.self) { i in
                        let data = moduleData[i]
                        moduleCard(index: i, title: data.0, ver: data.1, desc: data.2, isDangerous: data.3)
                    }
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 12)
            }
        }
        .alert("SpringBoard Injection", isPresented: $showConfirm) {
            Button("Cancel", role: .cancel) {
                if let idx = pendingToggleIndex { mods[idx].toggle() }
            }
            Button("Proceed", role: .destructive) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                // Action allowed
            }
        } message: {
            Text("This tweak hooks deeply into system daemons. Enabling it incorrectly may cause a respring loop.")
        }
    }
    
    private func moduleCard(index: Int, title: String, ver: String, desc: String, isDangerous: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(mods[index] ? ksOnSurface : ksSummary)
                        
                        if isDangerous {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(ksYellow)
                        }
                    }
                    Text(ver)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(ksSummary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(4)
                }
                Spacer()
                
                Toggle("", isOn: $mods[index])
                    .labelsHidden()
                    .tint(ksGreen)
                    .onChange(of: mods[index]) { newVal in
                        if newVal && isDangerous {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            pendingToggleIndex = index
                            showConfirm = true
                        } else {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
            }
            
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 0.5)
                .padding(.vertical, 10)
            
            Text(desc)
                .font(.system(size: 13))
                .foregroundColor(ksSummary)
                .lineLimit(2)
        }
        .padding(16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
        .opacity(mods[index] ? 1 : 0.7)
    }
}
