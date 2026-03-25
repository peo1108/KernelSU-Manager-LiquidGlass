import SwiftUI

// MARK: - iOS 26 Floating Tab Bar Constants
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

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
            
            // Content
            ZStack {
                HomeView()
                    .opacity(selectedTab == 0 ? 1 : 0)
                SuperuserView()
                    .opacity(selectedTab == 1 ? 1 : 0)
                ModulesView()
                    .opacity(selectedTab == 2 ? 1 : 0)
                LogsView()
                    .opacity(selectedTab == 3 ? 1 : 0)
            }
            
            // iOS 26 Floating Bottom Bar
            VStack {
                Spacer()
                FloatingTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Floating Tab Bar (iOS 26 Style)
struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs: [(icon: String, label: String)] = [
        ("house.fill", "Home"),
        ("shield.fill", "Superuser"),
        ("puzzlepiece.extension.fill", "Modules"),
        ("doc.text.fill", "Logs")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: selectedTab == index ? 22 : 20, weight: .semibold))
                            .foregroundColor(selectedTab == index ? ksGreen : .white.opacity(0.45))
                            .scaleEffect(selectedTab == index ? 1.1 : 1.0)
                        
                        Text(tabs[index].label)
                            .font(.system(size: 10, weight: selectedTab == index ? .bold : .medium))
                            .foregroundColor(selectedTab == index ? ksGreen : .white.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 8)
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
        )
        .padding(.horizontal, 24)
    }
}
