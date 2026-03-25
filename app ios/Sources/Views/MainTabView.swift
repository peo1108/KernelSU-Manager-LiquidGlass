import SwiftUI
import UIKit
import LocalAuthentication

// MARK: - iOS 26 Floating Tab Bar Constants
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var isAuthenticated = false
    @State private var authError: String? = nil
    
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
            
            if isAuthenticated {
                // Content
                ZStack {
                    HomeView()
                        .opacity(selectedTab == 0 ? 1 : 0)
                        // Ignore pointer events if not active
                        .allowsHitTesting(selectedTab == 0)
                    
                    SuperuserView()
                        .opacity(selectedTab == 1 ? 1 : 0)
                        .allowsHitTesting(selectedTab == 1)
                    
                    ModulesView()
                        .opacity(selectedTab == 2 ? 1 : 0)
                        .allowsHitTesting(selectedTab == 2)
                    
                    LogsView()
                        .opacity(selectedTab == 3 ? 1 : 0)
                        .allowsHitTesting(selectedTab == 3)
                }
                
                // iOS 26 Floating Bottom Bar
                VStack {
                    Spacer()
                    FloatingTabBar(selectedTab: $selectedTab)
                        .padding(.bottom, 8)
                }
                .ignoresSafeArea(.keyboard)
            } else {
                // Face ID Splash Screen
                VStack(spacing: 24) {
                    Image(systemName: "faceid")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundColor(ksGreen)
                    
                    Text("KernelSU")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let error = authError {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            authenticate()
                        }
                        .padding()
                        .background(ksGreen.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundColor(ksGreen)
                    }
                }
                .onAppear(perform: authenticate)
            }
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access KernelSU system level modules.") { success, authError in
                DispatchQueue.main.async {
                    if success {
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.isAuthenticated = true
                        }
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    } else {
                        self.authError = authError?.localizedDescription ?? "Authentication failed."
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    }
                }
            }
        } else {
            // No biometrics, allow access (or simulate for simulator/no-passcode)
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isAuthenticated = true
                }
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
                    if selectedTab != index {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedTab = index
                        }
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
                .buttonStyle(PlainButtonStyle())
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
