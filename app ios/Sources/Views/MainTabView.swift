import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Liquid Glass Background Backdrop (Fake Wallpaper)
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.2),
                    Color(red: 0.05, green: 0.4, blue: 0.3),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                SuperuserView()
                    .tabItem {
                        Image(systemName: "shield.fill")
                        Text("Superuser")
                    }
                    .tag(1)
                    
                ModulesView()
                    .tabItem {
                        Image(systemName: "puzzlepiece.extension.fill")
                        Text("Modules")
                    }
                    .tag(2)
                    
                LogsView()
                    .tabItem {
                        Image(systemName: "doc.text.fill")
                        Text("Logs")
                    }
                    .tag(3)
            }
            .tint(Color(red: 0.2, green: 0.8, blue: 0.4))
        }
    }
}
