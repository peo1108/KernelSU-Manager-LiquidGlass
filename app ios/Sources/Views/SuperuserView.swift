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
                // Spacing from top
                Color.clear.frame(height: 6)
                
                LazyVStack(spacing: 0) {
                    ForEach(filteredApps, id: \.id) { app in
                        AppRow(app: app)
                    }
                }
            }
            .navigationTitle("Superuser")
            .searchable(text: $searchText, prompt: "Search apps")
        }
    }
}

struct AppRow: View {
    let app: AppInfo
    
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 14) {
            // App Icon Placeholder (Rounded)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(app.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(app.bundleId)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    if app.isRoot {
                        TagView(text: "ROOT", color: Color(red: 0.9, green: 0.3, blue: 0.3))
                    }
                    if app.isSystem {
                        TagView(text: "SYSTEM", color: Color(red: 0.3, green: 0.5, blue: 0.9))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white.opacity(0.4))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        // Liquid Glass surface exact opacity match (0.05 alpha)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        // macOS style entrance animation from bottom right (x: 400, y: 600)
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : 400, y: isVisible ? 0 : 600)
        .scaleEffect(isVisible ? 1 : 0.9)
        .onAppear {
            // Easing FastOutSlowIn with 800ms duration
            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.8)) {
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
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}
