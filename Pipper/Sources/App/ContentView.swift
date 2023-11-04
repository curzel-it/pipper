import Schwifty
import Swinject
import SwiftUI

struct ContentView: View {
    @StateObject var appState = Container.main.resolve(AppState.self)!
    
    var body: some View {
        VStack(spacing: .zero) {
            if appState.showToolbar {
                Toolbar()
                    .padding(.horizontal, .md)
                    .padding(.vertical, .sm)
            }
            
            ZStack {                
                WebView().opacity(appState.showHome ? 0 : 1)
                BookmarksPage().padding(.top, .sm).opacity(appState.showHome ? 1 : 0)
                
                UserMessages()
                    .padding(.bottom, 50)
                    .positioned(.bottom)
                
                if !appState.showToolbar {
                    ShowToolbarToggle()
                        .padding(.sm)
                        .positioned(.trailingBottom)
                }
            }
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primaryBackground)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 4)
            }
        )
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 9, height: 9)))
        .sheet(isPresented: $appState.showSettings) { SettingsView() }
        .sheet(isPresented: $appState.showSearch) { SearchView() }
        .opacity(appState.windowOpacity)
        .environmentObject(appState)
    }
}
