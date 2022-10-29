import SwiftUI

struct Homepage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            BookmarksGrid().padding()
        }
        .frame(minWidth: 320)
    }
}
