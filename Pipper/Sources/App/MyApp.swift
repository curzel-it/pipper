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
        .commands {
            CommandGroup(replacing: .newItem) {}

            CommandMenu("About") {
                Button("About the project") { URL(string: "https://github.com/curzel-it/pipper")?.visit() }
                Button("My YouTube Channel") { URL(string: "https://www.youtube.com/@HiddenMugs")?.visit() }
            }
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
