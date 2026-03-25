import SwiftUI
import UIKit

private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

struct LogsView: View {
    @State private var visibleCount: Int = 0
    @State private var cursorVisible: Bool = true
    
    private let entries: [(String, Int, String)] = [
        ("00:00:01", 0, "KernelSU version: 12345"),
        ("00:00:01", 0, "Build type: Release (GKI)"),
        ("00:00:01", 0, "Starting ksud daemon..."),
        ("00:00:01", 0, "SELinux mode: Enforcing"),
        ("00:00:02", 0, "Mounting /data/adb/modules overlay"),
        ("00:00:02", 0, "Loading module: Zygisk-LSPosed v1.9.2"),
        ("00:00:02", 0, "Loading module: Shamiko v1.1.1"),
        ("00:00:02", 0, "Loading module: PlayIntegrityFix v17.9"),
        ("00:00:02", 0, "Loading module: Tricky Store v1.2.4"),
        ("00:00:03", 0, "All modules loaded successfully"),
        ("00:00:03", 0, "Zygisk injection started"),
        ("00:00:04", 0, "System ready. Waiting for SU requests..."),
        ("00:01:12", 1, "SU request: com.zhiliaoapp.musically"),
        ("00:01:12", 0, "SU GRANTED -> TikTok"),
        ("00:02:10", 2, "SU DENIED -> com.facebook.Facebook"),
        ("00:03:45", 0, "Shamiko: Hiding root from GMS"),
        ("00:04:01", 0, "PlayIntegrityFix: DEVICE -> PASS"),
        ("00:05:22", 1, "SU request: com.facebook.Messenger"),
        ("00:05:22", 0, "SU GRANTED -> Messenger"),
        ("00:10:15", 0, "Tricky Store: STRONG -> PASS"),
        ("00:15:30", 2, "SU DENIED -> PUBG MOBILE"),
        ("00:20:00", 0, "Health check: system nominal"),
        ("00:25:44", 0, "LSPosed: Hooked 142 methods"),
        ("00:30:01", 0, "ksud idle, CPU 0.1%"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Logs")
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
                    ForEach(0..<visibleCount, id: \.self) { i in
                        logRow(i)
                        if i < entries.count - 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.04))
                                .frame(height: 0.5)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text(">")
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(ksGreen)
                        Rectangle()
                            .fill(ksGreen)
                            .frame(width: 8, height: 16)
                            .opacity(cursorVisible ? 1 : 0)
                    }
                    .padding(.vertical, 8)
                }
                .padding(12)
                .background(ksSurface05)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                
                Spacer().frame(height: 100)
            }
        }
        .onAppear {
            visibleCount = 0
            startTyping()
            startBlink()
        }
    }
    
    @ViewBuilder
    private func logRow(_ i: Int) -> some View {
        let entry = entries[i]
        let levelColor: Color = entry.1 == 0 ? ksGreen : (entry.1 == 1 ? .orange : .red)
        HStack(alignment: .top, spacing: 8) {
            Text("[\(entry.0)]")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(ksSummary)
                .frame(width: 75, alignment: .leading)
            Circle()
                .fill(levelColor)
                .frame(width: 6, height: 6)
                .padding(.top, 5)
            Text(entry.2)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(ksOnSurface.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
    
    private func startTyping() {
        Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { t in
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
