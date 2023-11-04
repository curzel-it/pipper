import Combine
import Foundation
import SwiftUI
import Schwifty

struct SearchView: View {
    @EnvironmentObject var appState: AppState
    @State var text: String = ""
    @FocusState var focused: Bool
    
    var body: some View {
        VStack(spacing: .md) {
            Text("Search").font(.title.bold()).positioned(.leading)
            
            TextField("Search...", text: $text)
                .focused($focused, equals: true)
                .onSubmit(searchOrVisit)
                .onAppear { focused = true }
            
            Button("Search", action: searchOrVisit)
                .positioned(.trailing)
                .keyboardShortcut(.cancelAction)
        }
        .padding()
        .onExitCommand(perform: close)
        .frame(minWidth: 400)
    }
    
    private func searchOrVisit() {
        appState.showHome = false
        appState.load(.search(input: text))
        close()
    }
    
    private func close() {
        withAnimation {
            appState.showSearch = false
        }
    }
}
