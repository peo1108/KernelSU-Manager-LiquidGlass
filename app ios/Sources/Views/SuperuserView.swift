import SwiftUI

// MARK: - Miuix Color Constants
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksRootBg = Color(red: 0.35, green: 0.20, blue: 0.20).opacity(0.6)
private let ksRootFg = Color(red: 1.0, green: 0.55, blue: 0.55).opacity(0.8)
private let ksSystemBg = Color(red: 0.20, green: 0.25, blue: 0.35).opacity(0.8)
private let ksSystemFg = Color(red: 0.75, green: 0.80, blue: 0.95)

// MARK: - App Icon Mapping
private let appIconMap: [String: (icon: String, colors: [Color])] = [
    "TikTok": ("music.note", [Color.pink, Color.cyan]),
    "Facebook": ("f.square.fill", [Color.blue, Color.blue.opacity(0.7)]),
    "Messenger": ("message.fill", [Color.purple, Color.blue]),
    "PUBG MOBILE": ("gamecontroller.fill", [Color.orange, Color.yellow]),
    "Instagram": ("camera.fill", [Color.purple, Color.orange]),
    "Twitter": ("bird.fill", [Color.cyan, Color.blue]),
    "YouTube": ("play.rectangle.fill", [Color.red, Color.red.opacity(0.7)]),
    "Telegram": ("paperplane.fill", [Color.blue, Color.cyan]),
    "WhatsApp": ("phone.fill", [Color.green, Color.green.opacity(0.7)]),
    "Netflix": ("play.tv.fill", [Color.red, Color.black]),
    "Spotify": ("waveform", [Color.green, Color.green.opacity(0.7)]),
    "Snapchat": ("camera.viewfinder", [Color.yellow, Color.yellow.opacity(0.7)]),
    "Discord": ("bubble.left.and.bubble.right.fill", [Color.indigo, Color.purple]),
    "Reddit": ("antenna.radiowaves.left.and.right", [Color.orange, Color.red]),
    "Pinterest": ("pin.fill", [Color.red, Color.red.opacity(0.8)]),
    "Google Maps": ("map.fill", [Color.green, Color.blue]),
    "Google Chrome": ("globe", [Color.blue, Color.red]),
    "Gmail": ("envelope.fill", [Color.red, Color.white]),
    "Google Photos": ("photo.stack.fill", [Color.red, Color.green]),
    "Zoom": ("video.fill", [Color.blue, Color.blue.opacity(0.7)]),
    "Microsoft Teams": ("person.3.fill", [Color.indigo, Color.purple]),
    "Safari": ("safari.fill", [Color.blue, Color.cyan]),
    "Camera": ("camera.fill", [Color.gray, Color.gray.opacity(0.7)]),
    "Settings": ("gearshape.fill", [Color.gray, Color.gray.opacity(0.7)]),
    "Messages": ("message.fill", [Color.green, Color.green.opacity(0.7)]),
    "Phone": ("phone.fill", [Color.green, Color.green.opacity(0.7)]),
    "Photos": ("photo.fill", [Color.white, Color.gray]),
    "App Store": ("bag.fill", [Color.blue, Color.blue.opacity(0.7)]),
    "Mail": ("envelope.fill", [Color.blue, Color.blue.opacity(0.7)]),
    "Zalo": ("message.badge.filled.fill", [Color.blue, Color.cyan]),
    "Shopee": ("bag.fill", [Color.orange, Color.red]),
    "Lazada": ("cart.fill", [Color.blue, Color.purple]),
    "Tiki": ("bag.fill", [Color.blue, Color.cyan]),
    "Grab": ("car.fill", [Color.green, Color.green.opacity(0.7)]),
    "Gojek": ("scooter", [Color.green, Color.green.opacity(0.7)]),
    "CapCut": ("scissors", [Color.white, Color.gray]),
    "Free Fire": ("flame.fill", [Color.orange, Color.red]),
    "Roblox": ("cube.fill", [Color.red, Color.gray]),
    "Genshin Impact": ("sparkles", [Color.cyan, Color.purple]),
    "Lien Quan Mobile": ("shield.fill", [Color.purple, Color.blue]),
    "MoMo": ("creditcard.fill", [Color.pink, Color.purple]),
    "MB Bank": ("building.columns.fill", [Color.blue, Color.purple]),
    "Vietcombank": ("building.columns.fill", [Color.green, Color.green.opacity(0.7)]),
    "Techcombank": ("building.columns.fill", [Color.red, Color.red.opacity(0.7)]),
    "VNeID": ("person.text.rectangle.fill", [Color.red, Color.yellow]),
    "VssID": ("cross.case.fill", [Color.blue, Color.green]),
    "Tinder": ("flame.fill", [Color.orange, Color.pink]),
    "Bumble": ("heart.fill", [Color.yellow, Color.orange]),
    "WeChat": ("bubble.left.and.bubble.right.fill", [Color.green, Color.green.opacity(0.7)]),
    "LINE": ("message.fill", [Color.green, Color.green.opacity(0.7)]),
    "Shazam": ("shazam.logo.fill", [Color.blue, Color.cyan]),
]

struct SuperuserView: View {
    @StateObject private var appManager = AppListManager()
    @State private var searchText = ""
    @State private var isLoaded = false
    
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
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text("Superuser")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Custom Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ksSummary)
                TextField("Search apps", text: $searchText)
                    .foregroundColor(ksOnSurface)
                    .accentColor(Color(red: 0.21, green: 0.82, blue: 0.40))
            }
            .padding(10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            if !isLoaded {
                // Skeleton Loader fake
                ScrollView {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Fetching root permissions from Kernel...")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(Color(red: 0.21, green: 0.82, blue: 0.40))
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        
                        ForEach(0..<8, id: \.self) { _ in
                            SkeletonAppRow()
                        }
                    }
                    .padding(.top, 6)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            isLoaded = true
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        Spacer().frame(height: 2)
                        ForEach(filteredApps, id: \.id) { app in
                            GroupItemRow(app: app)
                        }
                        Spacer().frame(height: 100) // Float tab bar padding
                    }
                }
            }
        }
    }
}

// MARK: - Skeleton Loader Row
private struct SkeletonAppRow: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(width: 48, height: 48)
                .padding(.trailing, 14)
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 180, height: 12)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
        .opacity(0.5 + 0.5 * sin(phase))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                phase = .pi
            }
        }
    }
}

// MARK: - Group Item Row
private struct GroupItemRow: View {
    let app: AppInfo
    @State private var animProgress: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            AppIconView(appName: app.name)
                .padding(.trailing, 14)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ksOnSurface)
                    .lineLimit(1)
                
                Text(app.bundleId)
                    .font(.system(size: 13))
                    .foregroundColor(ksSummary)
                    .lineLimit(1)
                
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
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.3))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ksSurface05)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
        .opacity(animProgress)
        .offset(
            x: (1 - animProgress) * 50,
            y: (1 - animProgress) * 50
        )
        .scaleEffect(0.95 + 0.05 * animProgress)
        .onAppear {
            withAnimation(.timingCurve(0.2, 0.8, 0.2, 1.0, duration: 0.6)) {
                animProgress = 1
            }
        }
    }
}

private struct AppIconView: View {
    let appName: String
    private var iconInfo: (icon: String, colors: [Color]) {
        if let mapped = appIconMap[appName] { return mapped }
        let hash = abs(appName.hashValue)
        let hue = Double(hash % 360) / 360.0
        return ("app.fill", [Color(hue: hue, saturation: 0.6, brightness: 0.8), Color(hue: hue, saturation: 0.8, brightness: 0.5)])
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: iconInfo.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: iconInfo.icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: 48, height: 48)
    }
}

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
