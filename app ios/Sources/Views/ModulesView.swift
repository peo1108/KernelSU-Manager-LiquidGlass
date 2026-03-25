import SwiftUI

// MARK: - Miuix Colors
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksDivider = Color.white.opacity(0.08)

// MARK: - Module Data Model
class ModuleData: ObservableObject {
    @Published var modules: [ModuleItem] = [
        ModuleItem(name: "Zygisk - LSPosed", version: "v1.9.2 (7024)", author: "LSPosed Developers", desc: "A Riru / Zygisk module trying to provide an ART hooking framework which delivers consistent APIs with the OG Xposed, leveraging LSPlant hooking framework.", enabled: true),
        ModuleItem(name: "Shamiko", version: "v1.1.1", author: "LSPosed Developers", desc: "Hide Magisk root, Zygisk itself and Zygisk modules.", enabled: true),
        ModuleItem(name: "PlayIntegrityFix", version: "v17.9", author: "chiteroman", desc: "Fix Play Integrity (and SafetyNet) verdicts to pass Device verdict.", enabled: true),
        ModuleItem(name: "Tricky Store", version: "v1.2.4", author: "5ec1cff", desc: "A trick of keystore to generate valid certificate for STRONG verdict.", enabled: true),
        ModuleItem(name: "ZygiskNext", version: "v1.3.1", author: "Dr-TSNG", desc: "Standalone implementation of Zygisk, providing Zygisk API support for KernelSU.", enabled: true),
        ModuleItem(name: "BootloopSaver", version: "v3.1", author: "Jeevuz", desc: "Saves your device from bootloop caused by a bad module. Disables modules after repeated boot failures.", enabled: false),
        ModuleItem(name: "BusyBox NDK", version: "v1.36.1", author: "osm0sis", desc: "A BusyBox binary built with full SELinux support using the Android NDK.", enabled: true),
        ModuleItem(name: "Font Manager", version: "v5.10.0", author: "mModule", desc: "Change system font systemlessly. Supports Google Fonts library.", enabled: false),
        ModuleItem(name: "Universal SafetyNet Fix", version: "v3.0", author: "kdrag0n", desc: "Universal fix for SafetyNet/Play Integrity on devices with unlocked bootloaders.", enabled: true),
        ModuleItem(name: "ACC - Advanced Charging Controller", version: "v2024.6.3", author: "VR-25", desc: "Advanced charging controller for Android. Your battery's best friend.", enabled: false),
    ]
}

struct ModuleItem: Identifiable {
    let id = UUID()
    let name: String
    let version: String
    let author: String
    let desc: String
    var enabled: Bool
}

struct ModulesView: View {
    @StateObject private var data = ModuleData()
    @State private var showInstallSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text("Modules")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    Spacer().frame(height: 4)
                    
                    // Install Module Button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        showInstallSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Install Module")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Image(systemName: "folder.fill")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(ksGreen)
                        .padding(16)
                        .background(ksGreen.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        // Glow on install button
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ksGreen.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Module Count
                    HStack {
                        Text("\(data.modules.filter { $0.enabled }.count) enabled")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(ksGreen)
                        Text("•")
                            .foregroundColor(ksSummary)
                        Text("\(data.modules.count) installed")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(ksSummary)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    
                    // Module Cards
                    ForEach($data.modules) { $module in
                        ModuleCard(module: $module)
                    }
                    
                    Spacer().frame(height: 100) // Float tab bar padding
                }
                .padding(.horizontal, 12)
            }
            .sheet(isPresented: $showInstallSheet) {
                InstallModuleSheet()
            }
        }
    }
}

// MARK: - Module Card
private struct ModuleCard: View {
    @Binding var module: ModuleItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: Title + Toggle
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(module.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(module.enabled ? ksOnSurface : ksOnSurface.opacity(0.5))
                        .lineLimit(1)
                    Text("\(module.version) by @\(module.author)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ksSummary)
                }
                Spacer()
                Toggle("", isOn: Binding<Bool>(
                    get: { module.enabled },
                    set: { newValue in
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        module.enabled = newValue
                    }
                ))
                .labelsHidden()
                .tint(ksGreen)
            }
            
            // Divider
            Rectangle()
                .fill(ksDivider)
                .frame(height: 0.5)
                .padding(.vertical, 8)
            
            // Description
            Text(module.desc)
                .font(.system(size: 14))
                .foregroundColor(module.enabled ? ksSummary : ksSummary.opacity(0.5))
                .lineLimit(3)
        }
        .padding(16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(module.enabled ? 1 : 0.7)
        // Glass border 1px
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }
}

// MARK: - Install Module Sheet
private struct InstallModuleSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.zipper")
                    .font(.system(size: 60))
                    .foregroundColor(ksGreen)
                
                Text("Select a Module ZIP")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(ksOnSurface)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    dismiss()
                }) {
                    Text("Browse Files")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(ksGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Install Module")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(ksGreen)
                }
            }
        }
    }
}
