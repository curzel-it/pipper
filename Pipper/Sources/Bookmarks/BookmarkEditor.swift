import Combine
import Schwifty
import SwiftUI

struct BookmarkEditor: View {
    @EnvironmentObject var appState: AppState
    @Binding var editing: Bool    
    @State var title: String
    @State var icon: String
    @State var url: String
    
    let viewTitle: String
    let id: String
    
    init(editing: Binding<Bool>, original: Bookmark?) {
        self._editing = editing
        
        if let bookmark = original {
            id = bookmark.id
            title = bookmark.title
            url = bookmark.url
            icon = bookmark.icon
            viewTitle = "Edit '\(bookmark.title)'"
        } else {
            id = UUID().uuidString
            title = ""
            url = ""
            icon = ""
            viewTitle = "New Bookmark"
        }
    }
    
    var body: some View {
        VStack {
            Text(viewTitle)
                .font(.title.bold())
                .positioned(.leading)
                .padding(.bottom, 8)
            
            FormField(title: "Title", titleWidth: 50) { TextField("", text: $title) }
            FormField(title: "URL", titleWidth: 50) { TextField("", text: $url) }
            FormField(title: "Icon", titleWidth: 50) { TextField("", text: $icon) }
                .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Button("Close", action: close).keyboardShortcut(.cancelAction)
                Button("Save", action: save).keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .onReceive(Just(url)) { updateIconUrl(from: $0) }
        .onSubmit(save)
    }
    
    private func close() {
        withAnimation {
            editing = false
        }
    }
    
    private func updateIconUrl(from newUrl: String) {
        let tokens = icon.components(separatedBy: "/favicon.ico")
        guard tokens.count >= 1 else { return }
        guard tokens[0] == "" || url.contains(tokens[0]) else { return }
        icon = "\(newUrl)/favicon.ico"
            .replacingOccurrences(of: "//favicon.ico", with: "/favicon.ico")
    }
     
    private func save() {
        let item = Bookmark(id: id, title: title, url: url, icon: icon)
        withAnimation {
            appState.add(bookmark: item)
            editing = false            
            appState.userMessage = UserMessage(
                text: "'\(title)' added to your bookmarks",
                duracy: .short,
                severity: .success
            )
        }
    }
}
