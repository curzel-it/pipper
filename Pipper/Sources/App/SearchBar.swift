import Combine
import Foundation
import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var appState: AppState
    @State var text: String = ""
    @FocusState var focused: Bool
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .textFieldStyle(.plain)
                .padding()
                .onSubmit(searchOrVisit)
                .focused($focused)
                .onAppear { focused = true }
        }
        .padding(.trailing)
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .shadow(radius: 16)
        .padding(.horizontal, 40)
        .onSubmit(searchOrVisit)
        .onExitCommand(perform: close)
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
