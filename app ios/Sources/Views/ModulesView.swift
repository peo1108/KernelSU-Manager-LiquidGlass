import SwiftUI

// MARK: - Miuix Colors
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksDivider = Color.white.opacity(0.08)

struct ModulesView: View {
    let modules: [MockModule] = [
        MockModule(name: "Zygisk - LSPosed", version: "v1.9.2 (7024)", author: "LSPosed Developers", description: "Xposed framework module loader using Zygisk", enabled: true),
        MockModule(name: "Shamiko", version: "v1.1.1", author: "LSPosed Developers", description: "Hide Magisk root, Zygisk itself and modules", enabled: true),
        MockModule(name: "PlayIntegrityFix", version: "v17.9", author: "chiteroman", description: "Fix Play Integrity (and SafetyNet) verdicts", enabled: true),
        MockModule(name: "BootloopSaver", version: "v3.1", author: "Jeevuz", description: "Disable modules after several boot loops", enabled: false),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(modules, id: \.name) { mod in
                        ModuleCard(module: mod)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Color.clear)
            .navigationTitle("Modules")
        }
    }
}

// MARK: - Module Card (matches Android TemplateMiuix Card style)
private struct ModuleCard: View {
    let module: MockModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row: Title + Toggle
            HStack {
                Text(module.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ksOnSurface)
                    .lineLimit(1)
                Spacer()
                Toggle("", isOn: .constant(module.enabled))
                    .labelsHidden()
                    .tint(ksGreen)
            }
            
            // Version + Author
            Text("\(module.version) by @\(module.author)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ksSummary)
                .padding(.top, 1)
            
            // Divider
            Rectangle()
                .fill(ksDivider)
                .frame(height: 0.5)
                .padding(.vertical, 8)
            
            // Description
            Text(module.description)
                .font(.system(size: 14))
                .foregroundColor(ksSummary)
        }
        .padding(16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Data Model
struct MockModule {
    let name: String
    let version: String
    let author: String
    let description: String
    let enabled: Bool
}
