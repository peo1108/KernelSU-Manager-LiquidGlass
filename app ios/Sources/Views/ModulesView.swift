import SwiftUI

struct ModulesView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Installed Modules")) {
                    ModuleRow(title: "Zygisk - LSPosed", version: "v1.9.2 (7024)", author: "LSPosed Developers")
                    ModuleRow(title: "iOS TrollUI", version: "v2.0.1", author: "AppleTroll")
                    ModuleRow(title: "PUBG NoRecoil Bypass", version: "v4.0.0", author: "CheaterXX")
                }
            }
            .navigationTitle("Modules")
        }
    }
}

struct ModuleRow: View {
    let title: String
    let version: String
    let author: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(version).font(.subheadline)
            Text("by \(author)").font(.caption).foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
