import Schwifty
import SwiftUI

struct ContentView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        ZStack {
            WebView().opacity(appState.showHome ? 0 : 1)
            Homepage().opacity(appState.showHome ? 1 : 0)
            if appState.showSearch { SearchBar() }
            UserMessages()
        }
        .sheet(isPresented: $appState.showSettings) { SettingsView() }
        .browsingToolbar()
        .onWindow { appState.windowManager.setup(window: $0) }
        .environmentObject(appState)
    }
}
