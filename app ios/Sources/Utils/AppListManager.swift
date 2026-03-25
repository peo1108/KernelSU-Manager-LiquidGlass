import Foundation

struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let bundleId: String
    let isRoot: Bool
    let isSystem: Bool
}

class AppListManager: ObservableObject {
    @Published var apps: [AppInfo] = []
    
    init() {
        fetchApps()
    }
    
    func fetchApps() {
        // Fallback to Mock Apps Immediately for Simulator/Windows CI
        #if targetEnvironment(simulator)
        print("Simulator detected: Fallback to Mock apps.")
        self.apps = loadMockApps()
        return
        #endif
        
        let workspaceClass: AnyClass? = NSClassFromString("LSApplicationWorkspace")
        if let workspaceClass = workspaceClass as? NSObject.Type {
            let selector = NSSelectorFromString("defaultWorkspace")
            if workspaceClass.responds(to: selector),
               let workspace = workspaceClass.perform(selector)?.takeUnretainedValue() as? NSObject {
                
                let appsSelector = NSSelectorFromString("allInstalledApplications")
                if workspace.responds(to: appsSelector),
                   let appProxies = workspace.perform(appsSelector)?.takeUnretainedValue() as? [NSObject] {
                    
                    var loadedApps: [AppInfo] = []
                    for proxy in appProxies {
                        let nameSelector = NSSelectorFromString("localizedName")
                        let bundleSelector = NSSelectorFromString("applicationIdentifier")
                        
                        let name = (proxy.responds(to: nameSelector) ? proxy.perform(nameSelector)?.takeUnretainedValue() as? String : nil) ?? "Unknown App"
                        let bundleId = (proxy.responds(to: bundleSelector) ? proxy.perform(bundleSelector)?.takeUnretainedValue() as? String : nil) ?? "com.unknown"
                        
                        let isSystem = bundleId.hasPrefix("com.apple.")
                        loadedApps.append(AppInfo(name: name, bundleId: bundleId, isRoot: false, isSystem: isSystem))
                    }
                    
                    if !loadedApps.isEmpty {
                        DispatchQueue.main.async {
                            self.apps = loadedApps.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                        }
                        return
                    }
                }
            }
        }
        
        // Fallback if Sandbox restricts
        DispatchQueue.main.async {
            self.apps = self.loadMockApps()
        }
    }

    private func loadMockApps() -> [AppInfo] {
        return [
            AppInfo(name: "TikTok", bundleId: "com.zhiliaoapp.musically", isRoot: true, isSystem: false),
            AppInfo(name: "Facebook", bundleId: "com.facebook.Facebook", isRoot: false, isSystem: false),
            AppInfo(name: "Messenger", bundleId: "com.facebook.Messenger", isRoot: true, isSystem: false),
            AppInfo(name: "PUBG MOBILE", bundleId: "com.tencent.ig", isRoot: false, isSystem: false),
            AppInfo(name: "Settings", bundleId: "com.apple.Preferences", isRoot: false, isSystem: true),
            AppInfo(name: "Camera", bundleId: "com.apple.camera", isRoot: false, isSystem: true),
            AppInfo(name: "Zalo", bundleId: "com.zing.zalo", isRoot: false, isSystem: false),
            AppInfo(name: "YouTube", bundleId: "com.google.ios.youtube", isRoot: false, isSystem: false),
            AppInfo(name: "Instagram", bundleId: "com.burbn.instagram", isRoot: false, isSystem: false),
            AppInfo(name: "Twitter", bundleId: "com.atebits.Tweetie2", isRoot: true, isSystem: false),
            AppInfo(name: "Telegram", bundleId: "ph.telegra.Telegraph", isRoot: false, isSystem: false),
            AppInfo(name: "WhatsApp", bundleId: "net.whatsapp.WhatsApp", isRoot: false, isSystem: false),
            AppInfo(name: "Netflix", bundleId: "com.netflix.Netflix", isRoot: false, isSystem: false),
            AppInfo(name: "Spotify", bundleId: "com.spotify.client", isRoot: false, isSystem: false),
            AppInfo(name: "Shopee", bundleId: "com.shopee.vn", isRoot: false, isSystem: false),
            AppInfo(name: "Lazada", bundleId: "com.lazada.iphone", isRoot: false, isSystem: false),
            AppInfo(name: "Tiki", bundleId: "vn.tiki.app.tikiios", isRoot: false, isSystem: false),
            AppInfo(name: "Grab", bundleId: "com.grabtaxi.passenger", isRoot: false, isSystem: false),
            AppInfo(name: "Gojek", bundleId: "com.gojek.app", isRoot: false, isSystem: false),
            AppInfo(name: "Snapchat", bundleId: "com.toyopagroup.picaboo", isRoot: false, isSystem: false),
            AppInfo(name: "Pinterest", bundleId: "pinterest", isRoot: false, isSystem: false),
            AppInfo(name: "Reddit", bundleId: "com.reddit.Reddit", isRoot: false, isSystem: false),
            AppInfo(name: "Discord", bundleId: "com.hammerandchisel.discord", isRoot: false, isSystem: false),
            AppInfo(name: "Google Maps", bundleId: "com.google.Maps", isRoot: false, isSystem: false),
            AppInfo(name: "Google Chrome", bundleId: "com.google.chrome.ios", isRoot: false, isSystem: false),
            AppInfo(name: "Gmail", bundleId: "com.google.email", isRoot: false, isSystem: false),
            AppInfo(name: "Google Photos", bundleId: "com.google.photos", isRoot: false, isSystem: false),
            AppInfo(name: "CapCut", bundleId: "com.lemon.jy.ios", isRoot: false, isSystem: false),
            AppInfo(name: "Zoom", bundleId: "us.zoom.videomeetings", isRoot: false, isSystem: false),
            AppInfo(name: "Microsoft Teams", bundleId: "com.microsoft.skype.teams", isRoot: false, isSystem: false),
            AppInfo(name: "Lien Quan Mobile", bundleId: "com.garena.game.kgvn", isRoot: false, isSystem: false),
            AppInfo(name: "Free Fire", bundleId: "com.dts.freefireth", isRoot: false, isSystem: false),
            AppInfo(name: "Roblox", bundleId: "com.roblox.robloxmobile", isRoot: false, isSystem: false),
            AppInfo(name: "Genshin Impact", bundleId: "com.miHoYo.GenshinImpact", isRoot: false, isSystem: false),
            AppInfo(name: "Safari", bundleId: "com.apple.mobilesafari", isRoot: false, isSystem: true),
            AppInfo(name: "Messages", bundleId: "com.apple.MobileSMS", isRoot: false, isSystem: true),
            AppInfo(name: "Phone", bundleId: "com.apple.mobilephone", isRoot: false, isSystem: true),
            AppInfo(name: "Photos", bundleId: "com.apple.mobileslideshow", isRoot: false, isSystem: true),
            AppInfo(name: "App Store", bundleId: "com.apple.AppStore", isRoot: false, isSystem: true),
            AppInfo(name: "Mail", bundleId: "com.apple.mobilemail", isRoot: false, isSystem: true),
            AppInfo(name: "Tinder", bundleId: "com.cardify.tinder", isRoot: false, isSystem: false),
            AppInfo(name: "Bumble", bundleId: "com.bumble.app", isRoot: false, isSystem: false),
            AppInfo(name: "WeChat", bundleId: "com.tencent.xin", isRoot: false, isSystem: false),
            AppInfo(name: "LINE", bundleId: "jp.naver.line", isRoot: false, isSystem: false),
            AppInfo(name: "Shazam", bundleId: "com.shazam.Shazam", isRoot: false, isSystem: false),
            AppInfo(name: "MoMo", bundleId: "com.mservice.momotransfer", isRoot: false, isSystem: false),
            AppInfo(name: "MB Bank", bundleId: "com.mbmobile", isRoot: false, isSystem: false),
            AppInfo(name: "Vietcombank", bundleId: "com.VCB", isRoot: false, isSystem: false),
            AppInfo(name: "Techcombank", bundleId: "vn.com.techcombank.f@stmobile", isRoot: false, isSystem: false),
            AppInfo(name: "VNeID", bundleId: "vn.gov.bca.vneid", isRoot: false, isSystem: false),
            AppInfo(name: "VssID", bundleId: "vn.gov.baohiemxahoi.vssid", isRoot: false, isSystem: false)
        ].sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
