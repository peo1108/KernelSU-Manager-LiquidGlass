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
        ("Zygisk - LSPosed", "v1.9.2-release", "ART hooking framework", false),
        ("Shamiko", "v1.1.1-182", "Hide Magisk root, Zygisk", false),
        ("PlayIntegrityFix", "v17.9", "Pass Device verdict", false),
        ("Tricky Store", "v1.2.4", "Generate valid certificates", true), // Dangerous
        ("ZygiskNext", "v1.3.1", "Standalone Zygisk API", false),
        ("BootloopSaver", "v3.1", "Save from bootloops", true), // Dangerous
        ("BusyBox NDK", "v1.36.1", "Sys binary tools", false),
        ("Font Manager", "v5.10.0", "Change system font", false),
        ("SafetyNet Fix", "v3.0", "Legacy SafetyNet", false),
        ("ACC", "v2024.6", "Advanced battery logic", true) // Dangerous
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Modules")
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
        .alert("System Modification", isPresented: $showConfirm) {
            Button("Cancel", role: .cancel) {
                if let idx = pendingToggleIndex { mods[idx].toggle() }
            }
            Button("Proceed", role: .destructive) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                // Action allowed
            }
        } message: {
            Text("This module interacts deeply with the kernel. Enabling it incorrectly may cause a bootloop.")
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
