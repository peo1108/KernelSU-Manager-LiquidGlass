import SwiftUI

struct LogsView: View {
    let logMockData = """
    [00:00:01] KernelSU version: 10000
    [00:00:01] Starting ksud (sandbox disabled)...
    [00:00:02] Loading modules from /var/mobile/Library/KernelSU
    [00:00:02] Loaded Zygisk - LSPosed
    [00:00:02] Loaded iOS TrollUI
    [00:00:02] Loaded PUBG NoRecoil Bypass
    [00:00:03] Injecting into zygote...
    [00:00:03] Done! System is ready.
    [00:01:45] Request SU access: com.zhiliaoapp.musically (GRANTED)
    [00:02:10] Request SU access: com.facebook.Facebook (DENIED)
    """
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(logMockData)
                    .font(.system(.footnote, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color.clear)
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }
            }
        }
    }
}
