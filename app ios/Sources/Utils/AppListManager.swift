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
            AppInfo(name: "Banking App", bundleId: "com.bank.app", isRoot: false, isSystem: false),
            AppInfo(name: "Instagram", bundleId: "com.burbn.instagram", isRoot: false, isSystem: false)
        ]
    }
}
