import SwiftUI
import UIKit

// MARK: - Miuix Colors
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

struct LogsView: View {
    let rawLogEntries: [LogEntry] = [
        LogEntry(time: "00:00:01", level: .info, msg: "KernelSU version: 12345"),
        LogEntry(time: "00:00:01", level: .info, msg: "Build type: Release (GKI)"),
        LogEntry(time: "00:00:01", level: .info, msg: "Starting ksud daemon..."),
        LogEntry(time: "00:00:01", level: .info, msg: "SELinux mode: Enforcing"),
        LogEntry(time: "00:00:02", level: .info, msg: "Mounting /data/adb/modules overlay"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: Zygisk - LSPosed v1.9.2"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: Shamiko v1.1.1"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: PlayIntegrityFix v17.9"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: Tricky Store v1.2.4"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: ZygiskNext v1.3.1"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading module: BusyBox NDK v1.36.1"),
        LogEntry(time: "00:00:03", level: .info, msg: "All 6 modules loaded successfully"),
        LogEntry(time: "00:00:03", level: .info, msg: "Zygisk injection started"),
        LogEntry(time: "00:00:03", level: .info, msg: "Hooking app_process for UID isolation"),
        LogEntry(time: "00:00:04", level: .info, msg: "Mount namespace set for 10 apps"),
        LogEntry(time: "00:00:04", level: .info, msg: "System is ready. Waiting for SU requests..."),
        LogEntry(time: "00:01:12", level: .warn, msg: "SU request: com.zhiliaoapp.musically (UID 10085)"),
        LogEntry(time: "00:01:12", level: .info, msg: "SU GRANTED → TikTok (ROOT profile applied)"),
        LogEntry(time: "00:02:10", level: .error, msg: "SU DENIED → com.facebook.Facebook (UID 10032)"),
        LogEntry(time: "00:02:10", level: .info, msg: "User denied SU for Facebook via notification"),
        LogEntry(time: "00:03:45", level: .info, msg: "Shamiko: Hiding root from com.google.android.gms"),
        LogEntry(time: "00:03:45", level: .info, msg: "Shamiko: DenyList applied for 24 packages"),
        LogEntry(time: "00:04:01", level: .info, msg: "PlayIntegrityFix: Spoofed device fingerprint"),
        LogEntry(time: "00:04:01", level: .info, msg: "PlayIntegrityFix: DEVICE verdict → PASS"),
        LogEntry(time: "00:05:22", level: .warn, msg: "SU request: com.facebook.Messenger (UID 10033)"),
        LogEntry(time: "00:05:22", level: .info, msg: "SU GRANTED → Messenger (ROOT profile applied)"),
        LogEntry(time: "00:08:33", level: .info, msg: "SELinux context restored for UID 10085"),
        LogEntry(time: "00:10:15", level: .info, msg: "Tricky Store: Certificate chain generated"),
        LogEntry(time: "00:10:15", level: .info, msg: "Tricky Store: STRONG verdict → PASS"),
        LogEntry(time: "00:12:01", level: .info, msg: "Overlay mount refresh: 6 modules active"),
        LogEntry(time: "00:15:30", level: .warn, msg: "Process com.tencent.ig requesting UID change"),
        LogEntry(time: "00:15:30", level: .error, msg: "SU DENIED → PUBG MOBILE (not in allowlist)"),
        LogEntry(time: "00:20:00", level: .info, msg: "Periodic health check: system nominal"),
        LogEntry(time: "00:25:44", level: .info, msg: "LSPosed: Hooked 142 methods across 8 modules"),
        LogEntry(time: "00:30:01", level: .info, msg: "Battery optimization: ksud idle, CPU 0.1%"),
    ]
    
    @State private var visibleLogCount = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text("Logs")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ksOnSurface)
                Spacer()
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(ksGreen)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<visibleLogCount, id: \.self) { i in
                            LogRow(entry: rawLogEntries[i])
                                .id(i)
                            
                            if i < rawLogEntries.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.04))
                                    .frame(height: 0.5)
                            }
                        }
                        
                        // Blinking cursor representing active terminal stream
                        HStack {
                            Text(">")
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(ksGreen)
                            BlinkingCursor()
                        }
                        .padding(.vertical, 8)
                        .id(rawLogEntries.count)
                    }
                    .padding(12)
                    .background(ksSurface05)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    // Glass border wrapper overlay
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    Spacer().frame(height: 100)
                }
                .onChange(of: visibleLogCount) { _ in
                    withAnimation {
                        proxy.scrollTo(visibleLogCount, anchor: .bottom)
                    }
                }
            }
        }
        .onAppear {
            visibleLogCount = 0
            startTypingEffect()
        }
    }
    
    // Typing Effect Logic
    private func startTypingEffect() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if visibleLogCount < rawLogEntries.count {
                visibleLogCount += 1
                if rawLogEntries[visibleLogCount - 1].level == .error {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                } else if visibleLogCount % 5 == 0 {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Blinking Cursor
private struct BlinkingCursor: View {
    @State private var isVisible = true
    var body: some View {
        Rectangle()
            .fill(ksGreen)
            .frame(width: 8, height: 16)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isVisible = false
                }
            }
    }
}

// MARK: - Log Row
private struct LogRow: View {
    let entry: LogEntry
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("[\(entry.time)]")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(ksSummary)
                .frame(width: 75, alignment: .leading)
            
            Circle()
                .fill(entry.level.color)
                .frame(width: 6, height: 6)
                .padding(.top, 5)
                // Glow effect on error circles
                .shadow(color: entry.level == .error ? Color.red : Color.clear, radius: 4, x: 0, y: 0)
            
            Text(entry.msg)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(ksOnSurface.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Data Models
enum LogLevel {
    case info, warn, error
    var color: Color {
        switch self {
        case .info: return Color(red: 0.21, green: 0.82, blue: 0.40)
        case .warn: return Color.orange
        case .error: return Color.red
        }
    }
}

struct LogEntry {
    let time: String
    let level: LogLevel
    let msg: String
}
