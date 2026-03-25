import SwiftUI
import UIKit

// MARK: - Miuix Color Constants
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksRootBg = Color(red: 0.35, green: 0.20, blue: 0.20).opacity(0.6)
private let ksRootFg = Color(red: 1.0, green: 0.55, blue: 0.55).opacity(0.8)
private let ksSystemBg = Color(red: 0.20, green: 0.25, blue: 0.35).opacity(0.8)
private let ksSystemFg = Color(red: 0.75, green: 0.80, blue: 0.95)

// MARK: - App Icon Helper (avoid large dictionary literal that causes Swift compiler timeout)
private func getAppIcon(for name: String) -> (icon: String, c1: Color, c2: Color) {
    switch name {
    case "TikTok": return ("music.note", .pink, .cyan)
    case "Facebook": return ("f.square.fill", .blue, .blue.opacity(0.7))
    case "Messenger": return ("message.fill", .purple, .blue)
    case "PUBG MOBILE": return ("gamecontroller.fill", .orange, .yellow)
    case "Instagram": return ("camera.fill", .purple, .orange)
    case "Twitter": return ("at", .cyan, .blue)
    case "YouTube": return ("play.rectangle.fill", .red, .red.opacity(0.7))
    case "Telegram": return ("paperplane.fill", .blue, .cyan)
    case "WhatsApp": return ("phone.fill", .green, .green.opacity(0.7))
    case "Netflix": return ("play.tv.fill", .red, .black)
    case "Spotify": return ("waveform", .green, .green.opacity(0.7))
    case "Snapchat": return ("camera.viewfinder", .yellow, .yellow.opacity(0.7))
    case "Discord": return ("bubble.left.and.bubble.right.fill", .indigo, .purple)
    case "Reddit": return ("antenna.radiowaves.left.and.right", .orange, .red)
    case "Pinterest": return ("pin.fill", .red, .red.opacity(0.8))
    case "Google Maps": return ("map.fill", .green, .blue)
    case "Google Chrome": return ("globe", .blue, .red)
    case "Gmail": return ("envelope.fill", .red, .orange)
    case "Zoom": return ("video.fill", .blue, .blue.opacity(0.7))
    case "Safari": return ("safari.fill", .blue, .cyan)
    case "Camera": return ("camera.fill", .gray, .gray.opacity(0.7))
    case "Settings": return ("gearshape.fill", .gray, .gray.opacity(0.7))
    case "Messages": return ("message.fill", .green, .green.opacity(0.7))
    case "Phone": return ("phone.fill", .green, .green.opacity(0.7))
    case "Photos": return ("photo.fill", .white, .gray)
    case "App Store": return ("bag.fill", .blue, .blue.opacity(0.7))
    case "Mail": return ("envelope.fill", .blue, .blue.opacity(0.7))
    case "Zalo": return ("ellipsis.message.fill", .blue, .cyan)
    case "Shopee": return ("bag.fill", .orange, .red)
    case "Lazada": return ("cart.fill", .blue, .purple)
    case "Grab": return ("car.fill", .green, .green.opacity(0.7))
    case "CapCut": return ("scissors", .white, .gray)
    case "Free Fire": return ("flame.fill", .orange, .red)
    case "Roblox": return ("cube.fill", .red, .gray)
    case "Genshin Impact": return ("sparkles", .cyan, .purple)
    case "MoMo": return ("creditcard.fill", .pink, .purple)
    case "MB Bank": return ("building.columns.fill", .blue, .purple)
    case "Vietcombank": return ("building.columns.fill", .green, .green.opacity(0.7))
    case "Techcombank": return ("building.columns.fill", .red, .red.opacity(0.7))
    case "VNeID": return ("person.text.rectangle.fill", .red, .yellow)
    case "Tinder": return ("flame.fill", .orange, .pink)
    case "Bumble": return ("heart.fill", .yellow, .orange)
    case "WeChat": return ("bubble.left.and.bubble.right.fill", .green, .green.opacity(0.7))
    case "LINE": return ("message.fill", .green, .green.opacity(0.7))
    default:
        let hash = abs(name.hashValue)
        let hue = Double(hash % 360) / 360.0
        return ("app.fill", Color(hue: hue, saturation: 0.6, brightness: 0.8), Color(hue: hue, saturation: 0.8, brightness: 0.5))
    }
}

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
            HStack {
                Text("Superuser")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
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
                        Spacer().frame(height: 100)
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
        .offset(x: (1 - animProgress) * 50, y: (1 - animProgress) * 50)
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
    var body: some View {
        let info = getAppIcon(for: appName)
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [info.c1, info.c2], startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: info.icon)
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
