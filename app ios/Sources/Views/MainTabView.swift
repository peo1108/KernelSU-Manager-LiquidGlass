import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Real wallpaper background from back.png
            Image("back")
                .resizable()
                .scaledToFill()
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
