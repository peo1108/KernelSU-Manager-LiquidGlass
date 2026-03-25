import SwiftUI
import UIKit

private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksRootBg = Color(red: 0.35, green: 0.20, blue: 0.20).opacity(0.6)
private let ksRootFg = Color(red: 1.0, green: 0.55, blue: 0.55).opacity(0.8)
private let ksSystemBg = Color(red: 0.20, green: 0.25, blue: 0.35).opacity(0.8)
private let ksSystemFg = Color(red: 0.75, green: 0.80, blue: 0.95)

private func iconForApp(_ name: String) -> (String, Color, Color) {
    switch name {
    case "TikTok": return ("music.note", .pink, .cyan)
    case "Facebook": return ("f.square.fill", .blue, .blue.opacity(0.7))
    case "Messenger": return ("message.fill", .purple, .blue)
    case "PUBG MOBILE": return ("gamecontroller.fill", .orange, .yellow)
    case "Instagram": return ("camera.fill", .purple, .orange)
    case "YouTube": return ("play.rectangle.fill", .red, .red.opacity(0.7))
    case "Telegram": return ("paperplane.fill", .blue, .cyan)
    case "WhatsApp": return ("phone.fill", .green, .green.opacity(0.7))
    case "Zalo": return ("message.fill", .blue, .cyan)
    case "Shopee": return ("bag.fill", .orange, .red)
    case "Discord": return ("bubble.left.and.bubble.right.fill", .indigo, .purple)
    case "Spotify": return ("waveform", .green, .green.opacity(0.7))
    case "Netflix": return ("play.tv.fill", .red, .black)
    case "Settings": return ("gearshape.fill", .gray, .gray.opacity(0.7))
    case "Safari": return ("safari.fill", .blue, .cyan)
    case "Camera": return ("camera.fill", .gray, .gray.opacity(0.7))
    case "Grab": return ("car.fill", .green, .green.opacity(0.7))
    case "MoMo": return ("creditcard.fill", .pink, .purple)
    case "Genshin Impact": return ("sparkles", .cyan, .purple)
    case "Free Fire": return ("flame.fill", .orange, .red)
    default:
        let h = Double(abs(name.hashValue) % 360) / 360.0
        let c1 = Color(hue: h, saturation: 0.6, brightness: 0.8)
        let c2 = Color(hue: h, saturation: 0.8, brightness: 0.5)
        return ("app.fill", c1, c2)
    }
}

struct SuperuserView: View {
    @StateObject private var appManager = AppListManager()
    @State private var searchText: String = ""
    @State private var isLoaded: Bool = false
    @State private var selectedApp: AppInfo?
    
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
                            Text("Fetching root permissions...")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(ksGreen)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        ForEach(0..<6, id: \.self) { _ in
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.08))
                                    .frame(width: 48, height: 48)
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.08))
                                        .frame(width: 120, height: 14)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.08))
                                        .frame(width: 180, height: 10)
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(ksSurface05)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 12)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { isLoaded = true }
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredApps()) { app in
                            appRow(app)
                        }
                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .sheet(item: $selectedApp) { app in
            AppProfileView(app: app, iconInfo: iconForApp(app.name))
        }
    }
    
    private func filteredApps() -> [AppInfo] {
        if searchText.isEmpty { return appManager.apps }
        return appManager.apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    private func appRow(_ app: AppInfo) -> some View {
        let info = iconForApp(app.name)
        return Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedApp = app
        }) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: [info.1, info.2], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: info.0)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(app.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ksOnSurface)
                        .lineLimit(1)
                    Text(app.bundleId)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(ksSummary)
                        .lineLimit(1)
                    if app.isRoot || app.isSystem {
                        HStack(spacing: 6) {
                            if app.isRoot {
                                tagView("[ ROOT ]", ksRootBg, ksRootFg)
                            }
                            if app.isSystem {
                                tagView("[ SYSTEM ]", ksSystemBg, ksSystemFg)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.2))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(ksSurface05)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
    }
    
    private func tagView(_ text: String, _ bg: Color, _ fg: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .foregroundColor(fg)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(bg.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(fg.opacity(0.3), lineWidth: 0.5))
    }
}

struct AppProfileView: View {
    let app: AppInfo
    let iconInfo: (String, Color, Color)
    @Environment(\.dismiss) var dismiss
    
    @State private var isRootEnabled: Bool
    @State private var unmountModules: Bool = false
    @State private var allowStorage: Bool = true
    
    init(app: AppInfo, iconInfo: (String, Color, Color)) {
        self.app = app
        self.iconInfo = iconInfo
        _isRootEnabled = State(initialValue: app.isRoot)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [iconInfo.1, iconInfo.2], startPoint: .topLeading, endPoint: .bottomTrailing))
                                Image(systemName: iconInfo.0)
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 80)
                            .shadow(color: iconInfo.1.opacity(0.3), radius: 10, y: 5)
                            
                            VStack(spacing: 4) {
                                Text(app.name)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Text(app.bundleId)
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(Color.white.opacity(0.55))
                            }
                        }
                        .padding(.top, 24)
                        
                        // Toggles
                        VStack(spacing: 0) {
                            toggleRow("Enable Superuser", $isRootEnabled, icon: "key.fill", color: .orange)
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 50)
                            toggleRow("Unmount Modules", $unmountModules, icon: "puzzlepiece.extension.fill", color: .purple)
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 50)
                            toggleRow("Storage Isolation", $allowStorage, icon: "externaldrive.fill", color: .cyan)
                        }
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
                        .padding(.horizontal, 16)
                        
                        // Danger Zone
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DANGER ZONE")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.4))
                                .padding(.leading, 12)
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                isRootEnabled = false
                                dismiss()
                            }) {
                                HStack {
                                    Text("Revoke Permissions")
                                        .font(.system(size: 16, weight: .semibold))
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding(16)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.3), lineWidth: 0.5))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Text("Done").bold().foregroundColor(Color(red: 0.21, green: 0.82, blue: 0.40))
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func toggleRow(_ title: String, _ binding: Binding<Bool>, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Rectangle().fill(color).frame(width: 32, height: 32).cornerRadius(8)
                Image(systemName: icon).foregroundColor(.white).font(.system(size: 14, weight: .semibold))
            }
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: binding)
                .labelsHidden()
                .tint(Color(red: 0.21, green: 0.82, blue: 0.40))
        }
        .padding(12)
    }
}
