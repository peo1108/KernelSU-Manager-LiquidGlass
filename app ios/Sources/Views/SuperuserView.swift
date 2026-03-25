import SwiftUI

struct SuperuserView: View {
    @StateObject private var appManager = AppListManager()
    @State private var searchText = ""
    
    var filteredApps: [AppInfo] {
        if searchText.isEmpty {
            return appManager.apps
        } else {
            return appManager.apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.bundleId.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(filteredApps.enumerated()), id: \.element.id) { index, app in
                        AppRow(app: app, delay: 0.05) // Small delay instead of pure sequence to avoid over-delaying
                    }
                }
                .padding()
            }
            .navigationTitle("Superuser")
            .searchable(text: $searchText, prompt: "Search apps")
        }
    }
}

struct AppRow: View {
    let app: AppInfo
    let delay: Double
    
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Placeholder for App Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray4))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(app.name.prefix(1)))
                        .font(.title2)
                        .foregroundColor(.primary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(app.bundleId)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    if app.isRoot {
                        TagView(text: "ROOT", color: .red)
                    }
                    if app.isSystem {
                        TagView(text: "SYSTEM", color: .blue)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        // macOS style entrance animation from bottom right
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : 200, y: isVisible ? 0 : 300)
        .scaleEffect(isVisible ? 1 : 0.8)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(delay)) {
                isVisible = true
            }
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}
