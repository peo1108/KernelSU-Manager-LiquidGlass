import SwiftUI
import UIKit

private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)
private let ksBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
private let ksOrange = Color.orange
private let ksRed = Color.red

struct LogsView: View {
    @State private var visibleCount: Int = 0
    @State private var cursorVisible: Bool = true
    
    // 0: INFO, 1: WARN, 2: ERROR
    private let entries: [(String, Int, String, String)] = [
        ("00:00:01.002", 0, "jbinit", "Jailbreak environment initialized (rootfs)"),
        ("00:00:01.045", 0, "core", "SSV authentication bypassed successfully"),
        ("00:00:02.100", 0, "mount", "Mounting /var/jb overlay"),
        ("00:00:02.320", 0, "ellekit", "Loading tweak: SnowBoard.dylib v1.5.21"),
        ("00:00:02.405", 2, "substrate", "Failed to hook CGSSetWindowProperty, retrying..."),
        ("00:00:02.601", 0, "ellekit", "Tweak loaded via fallback unsandbox hook."),
        ("00:00:03.111", 0, "jailbreakd", "System ready. Waiting for SSH/SU requests..."),
        ("00:01:12.890", 1, "su", "SU request PID 4591: com.apple.Preferences"),
        ("00:01:12.902", 0, "su", "SU GRANTED -> Settings (UID: 0)"),
        ("00:02:10.432", 2, "su", "SU DENIED -> com.facebook.Facebook"),
        ("00:03:45.001", 0, "choicy", "Blocking injection into com.apple.mobilesafari"),
        ("00:05:22.560", 1, "sshd", "Connection from 127.0.0.1 on port 2222"),
        ("00:05:22.580", 0, "sshd", "Accepted publickey for root from 127.0.0.1"),
        ("00:15:30.900", 2, "kernel", "sandbox map lookup failed: com.rovio.angrybirds"),
        ("00:20:00.000", 0, "launchd", "Health check: system nominal, memory 45MB"),
        ("00:30:01.444", 0, "jailbreakd", "jailbreakd idle, CPU 0.1%"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Diagnostics")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(ksGreen)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("CONSOLE OUTPUT")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(ksSummary)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    ForEach(0..<visibleCount, id: \.self) { i in
                        logRow(i)
                    }
                    
                    HStack(spacing: 4) {
                        Text("mobile@iPhone-16-Pro-Max:~ $")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(ksGreen)
                        Rectangle()
                            .fill(ksGreen)
                            .frame(width: 8, height: 16)
                            .opacity(cursorVisible ? 1 : 0)
                    }
                    .padding(.vertical, 8)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .padding(.horizontal, 12)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            visibleCount = 0
            startTyping()
            startBlink()
        }
    }
    
    private func logRow(_ i: Int) -> some View {
        let entry = entries[i]
        
        let tagColor: Color
        let tagText: String
        switch entry.1 {
        case 1: tagColor = ksOrange; tagText = "WARN"
        case 2: tagColor = ksRed; tagText = "ERR "
        default: tagColor = ksBlue; tagText = "INFO"
        }
        
        return VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .top, spacing: 6) {
                Text("[\(entry.0)]")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(ksSummary)
                
                Text(tagText)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(tagColor)
                
                Text("<\(entry.2)>")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.purple.opacity(0.8))
            }
            Text(entry.3)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(ksOnSurface.opacity(0.9))
                .padding(.leading, 12)
        }
        .padding(.vertical, 4)
    }
    
    private func startTyping() {
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { t in
            if visibleCount < entries.count {
                visibleCount += 1
            } else {
                t.invalidate()
            }
        }
    }
    
    private func startBlink() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            cursorVisible.toggle()
        }
    }
}
