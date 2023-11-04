import SwiftUI

@main
struct PipperApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    init() {
        Dependencies.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            EmptyView().onWindow { $0.close() }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {        
        @Inject var appState: AppState
        @Inject var windowManager: WindowManager
        windowManager.resetAccessoryMode(enabled: appState.accessoryMode)
        windowManager.newWindow()
    }
}
