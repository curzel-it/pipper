//
//  BookmarkEditor.swift
//  Pipper
//
//  Created by Federico Curzel on 31/07/22.
//

import Schwifty
import SwiftUI

struct BookmarkEditor: View {
    
    @EnvironmentObject var appState: AppState
    
    @Binding var editing: Bool
    let viewTitle: String
    
    let id: String
    @State var title: String
    @State var icon: String
    @State var url: String
    
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
                .font(.title3.bold())
                .positioned(.leading)
                .padding(.bottom, 8)
            
            FormField(title: "Title", titleWidth: 50) { TextField("", text: $title) }
            FormField(title: "URL", titleWidth: 50) { TextField("", text: $url) }
            FormField(title: "Icon", titleWidth: 50) { TextField("", text: $icon) }
                .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Button("Close") { editing = false }
                    .keyboardShortcut(.cancelAction)
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .frame(width: 300)
        .padding()
        .onSubmit(save)
    }
    
    private func save() {
        let item = Bookmark(id: id, title: title, url: url, icon: icon)
        withAnimation {
            appState.bookmarks.removeAll { $0.id == id }
            appState.bookmarks.append(item)
            
            editing = false
            
            appState.userMessage = UserMessage(
                text: "'\(title)' added to your bookmarks",
                duracy: .short,
                severity: .success
            )
        }
    }
}
