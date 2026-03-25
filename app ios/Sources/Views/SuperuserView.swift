import SwiftUI

// MARK: - Miuix Color Constants
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksRootBg = Color(red: 0.35, green: 0.20, blue: 0.20).opacity(0.6)   // tertiaryContainer
private let ksRootFg = Color(red: 1.0, green: 0.55, blue: 0.55).opacity(0.8)
private let ksSystemBg = Color(red: 0.20, green: 0.25, blue: 0.35).opacity(0.8)  // secondaryContainer
private let ksSystemFg = Color(red: 0.75, green: 0.80, blue: 0.95)
private let ksPrimary = Color(red: 0.21, green: 0.82, blue: 0.40)

struct SuperuserView: View {
    @StateObject private var appManager = AppListManager()
    @State private var searchText = ""
    
    var filteredApps: [AppInfo] {
        if searchText.isEmpty {
            return appManager.apps
        } else {
            return appManager.apps.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.bundleId.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Top spacing
                    Spacer().frame(height: 6)
                    
                    ForEach(filteredApps, id: \.id) { app in
                        GroupItemRow(app: app)
                    }
                }
            }
            .background(Color.clear)
            .navigationTitle("Superuser")
            .searchable(text: $searchText, prompt: "Search apps")
        }
    }
}

// MARK: - Group Item Row (matches Android GroupItem)
private struct GroupItemRow: View {
    let app: AppInfo
    @State private var animProgress: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // App Icon (48dp, rounded)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                Text(String(app.name.prefix(1)))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(ksOnSurface)
            }
            .frame(width: 48, height: 48)
            .padding(.trailing, 14)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ksOnSurface)
                    .lineLimit(1)
                
                Text(app.bundleId)
                    .font(.system(size: 13))
                    .foregroundColor(ksSummary)
                    .lineLimit(1)
                
                // Tags row
                if app.isRoot || app.isSystem {
                    HStack(spacing: 6) {
                        if app.isRoot {
                            KSUTag(text: "ROOT", bg: ksRootBg, fg: ksRootFg)
                        }
                        if app.isSystem {
                            KSUTag(text: "SYSTEM", bg: ksSystemBg, fg: ksSystemFg)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.3))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        // macOS entrance animation (x:400, y:600, scale:0.9, 800ms FastOutSlowIn)
        .opacity(animProgress)
        .offset(
            x: (1 - animProgress) * 400,
            y: (1 - animProgress) * 600
        )
        .scaleEffect(0.9 + 0.1 * animProgress)
        .onAppear {
            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.8)) {
                animProgress = 1
            }
        }
    }
}

// MARK: - KSU Tag (ROOT / SYSTEM / CUSTOM)
private struct KSUTag: View {
    let text: String
    let bg: Color
    let fg: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(fg)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
