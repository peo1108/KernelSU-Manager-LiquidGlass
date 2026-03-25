import SwiftUI

// MARK: - Miuix Colors
private let ksSurface05 = Color.white.opacity(0.05)
private let ksOnSurface = Color.white
private let ksSummary = Color.white.opacity(0.55)
private let ksGreen = Color(red: 0.21, green: 0.82, blue: 0.40)

struct LogsView: View {
    let logEntries: [LogEntry] = [
        LogEntry(time: "00:00:01", level: .info, msg: "KernelSU version: 12345"),
        LogEntry(time: "00:00:01", level: .info, msg: "Starting ksud..."),
        LogEntry(time: "00:00:02", level: .info, msg: "Loading modules from /data/adb/modules"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loaded: Zygisk - LSPosed"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loaded: Shamiko"),
        LogEntry(time: "00:00:02", level: .info, msg: "Loaded: PlayIntegrityFix"),
        LogEntry(time: "00:00:03", level: .info, msg: "Injecting into zygote..."),
        LogEntry(time: "00:00:03", level: .info, msg: "Done! System is ready."),
        LogEntry(time: "00:01:45", level: .warn, msg: "Request SU: com.zhiliaoapp.musically → GRANTED"),
        LogEntry(time: "00:02:10", level: .error, msg: "Request SU: com.facebook.Facebook → DENIED"),
        LogEntry(time: "00:05:22", level: .info, msg: "Module action: Shamiko hiding root from com.google.android.gms"),
        LogEntry(time: "00:08:33", level: .info, msg: "SELinux context restored for uid 10085"),
        LogEntry(time: "00:12:01", level: .warn, msg: "Mount namespace overlays applied: 3 modules"),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(logEntries.indices, id: \.self) { i in
                        LogRow(entry: logEntries[i])
                        
                        if i < logEntries.count - 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.04))
                                .frame(height: 0.5)
                        }
                    }
                }
                .padding(12)
                .background(ksSurface05)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Color.clear)
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(ksGreen)
                    }
                }
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
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(ksSummary)
                .frame(width: 80, alignment: .leading)
            
            Circle()
                .fill(entry.level.color)
                .frame(width: 6, height: 6)
                .padding(.top, 5)
            
            Text(entry.msg)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(ksOnSurface.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
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
