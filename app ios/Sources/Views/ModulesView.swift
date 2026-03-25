import SwiftUI
import UIKit

private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

struct ModulesView: View {
    @State private var mod1On: Bool = true
    @State private var mod2On: Bool = true
    @State private var mod3On: Bool = true
    @State private var mod4On: Bool = true
    @State private var mod5On: Bool = true
    @State private var mod6On: Bool = false
    @State private var mod7On: Bool = true
    @State private var mod8On: Bool = false
    @State private var mod9On: Bool = true
    @State private var mod10On: Bool = false
    @State private var showInstallSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
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
                    
                    Button(action: { showInstallSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Install Module")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Image(systemName: "folder.fill")
                        }
                        .foregroundColor(ksGreen)
                        .padding(16)
                        .background(ksGreen.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(ksGreen.opacity(0.3), lineWidth: 1))
                    }
                    
                    moduleCard(title: "Zygisk - LSPosed", ver: "v1.9.2", author: "LSPosed Developers", desc: "ART hooking framework with Xposed-compatible API.", isOn: $mod1On)
                    moduleCard(title: "Shamiko", ver: "v1.1.1", author: "LSPosed Developers", desc: "Hide Magisk root, Zygisk itself and Zygisk modules.", isOn: $mod2On)
                    moduleCard(title: "PlayIntegrityFix", ver: "v17.9", author: "chiteroman", desc: "Fix Play Integrity verdicts to pass Device verdict.", isOn: $mod3On)
                    moduleCard(title: "Tricky Store", ver: "v1.2.4", author: "5ec1cff", desc: "Generate valid certificate for STRONG verdict.", isOn: $mod4On)
                    moduleCard(title: "ZygiskNext", ver: "v1.3.1", author: "Dr-TSNG", desc: "Standalone Zygisk API support for KernelSU.", isOn: $mod5On)
                    moduleCard(title: "BootloopSaver", ver: "v3.1", author: "Jeevuz", desc: "Disables modules after repeated boot failures.", isOn: $mod6On)
                    moduleCard(title: "BusyBox NDK", ver: "v1.36.1", author: "osm0sis", desc: "BusyBox binary with full SELinux support.", isOn: $mod7On)
                    moduleCard(title: "Font Manager", ver: "v5.10.0", author: "mModule", desc: "Change system font systemlessly.", isOn: $mod8On)
                    moduleCard(title: "SafetyNet Fix", ver: "v3.0", author: "kdrag0n", desc: "Fix SafetyNet on unlocked bootloaders.", isOn: $mod9On)
                    moduleCard(title: "ACC", ver: "v2024.6", author: "VR-25", desc: "Advanced charging controller for Android.", isOn: $mod10On)
                    
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 12)
            }
            .sheet(isPresented: $showInstallSheet) {
                VStack(spacing: 20) {
                    Image(systemName: "doc.zipper")
                        .font(.system(size: 60))
                        .foregroundColor(ksGreen)
                    Text("Select a Module ZIP")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ksOnSurface)
                    Button("Browse Files") { showInstallSheet = false }
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(ksGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }
        }
    }
    
    @ViewBuilder
    private func moduleCard(title: String, ver: String, author: String, desc: String, isOn: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isOn.wrappedValue ? ksOnSurface : ksOnSurface.opacity(0.5))
                        .lineLimit(1)
                    Text("\(ver) by @\(author)")
                        .font(.system(size: 12))
                        .foregroundColor(ksSummary)
                }
                Spacer()
                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .tint(ksGreen)
            }
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 0.5)
                .padding(.vertical, 8)
            Text(desc)
                .font(.system(size: 14))
                .foregroundColor(ksSummary)
                .lineLimit(3)
        }
        .padding(16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
        .opacity(isOn.wrappedValue ? 1 : 0.7)
    }
}
