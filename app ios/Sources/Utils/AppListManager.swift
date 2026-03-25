import Foundation

struct AppInfo: Identifiable {
    let id: UUID
    let name: String
    let bundleId: String
    let isRoot: Bool
    let isSystem: Bool
    
    init(name: String, bundleId: String, isRoot: Bool, isSystem: Bool) {
        self.id = UUID()
        self.name = name
        self.bundleId = bundleId
        self.isRoot = isRoot
        self.isSystem = isSystem
    }
}

class AppListManager: ObservableObject {
    @Published var apps: [AppInfo] = []
    
    init() {
        self.apps = AppListManager.makeMockApps()
    }
    
    static func makeMockApps() -> [AppInfo] {
        var list: [AppInfo] = []
        list.append(AppInfo(name: "Sileo", bundleId: "org.coolstar.sileo", isRoot: true, isSystem: true))
        list.append(AppInfo(name: "Zebra", bundleId: "xyz.willy.Zebra", isRoot: true, isSystem: true))
        list.append(AppInfo(name: "TrollStore", bundleId: "com.opa334.TrollStore", isRoot: true, isSystem: true))
        list.append(AppInfo(name: "NewTerm 3", bundleId: "ws.hbang.Terminal", isRoot: true, isSystem: false))
        list.append(AppInfo(name: "TikTok", bundleId: "com.zhiliaoapp.musically", isRoot: true, isSystem: false))
        list.append(AppInfo(name: "Facebook", bundleId: "com.facebook.Facebook", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Messenger", bundleId: "com.facebook.Messenger", isRoot: true, isSystem: false))
        list.append(AppInfo(name: "PUBG MOBILE", bundleId: "com.tencent.ig", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Instagram", bundleId: "com.burbn.instagram", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "YouTube", bundleId: "com.google.ios.youtube", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Telegram", bundleId: "ph.telegra.Telegraph", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "WhatsApp", bundleId: "net.whatsapp.WhatsApp", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Zalo", bundleId: "com.zing.zalo", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Shopee", bundleId: "com.shopee.vn", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Discord", bundleId: "com.hammerandchisel.discord", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Spotify", bundleId: "com.spotify.client", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Netflix", bundleId: "com.netflix.Netflix", isRoot: false, isSystem: false))
        list.append(AppInfo(name: "Settings", bundleId: "com.apple.Preferences", isRoot: false, isSystem: true))
        list.append(AppInfo(name: "Safari", bundleId: "com.apple.mobilesafari", isRoot: false, isSystem: true))
        list.append(AppInfo(name: "Camera", bundleId: "com.apple.camera", isRoot: false, isSystem: true))
        list.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        return list
    }
}
