import SwiftUI

struct BookmarksPage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            BookmarksGrid()
        }
        .frame(minWidth: 320)
        .padding(.horizontal, .md)   
    }
}
