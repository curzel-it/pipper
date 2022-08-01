//
//  Bookmarks.swift
//  Pipper
//
//  Created by Federico Curzel on 30/07/22.
//

import Kingfisher
import Schwifty
import SwiftUI

struct BookmarksGrid: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var showingEditor: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Bookmarks")
                    .font(.title.bold())
                Spacer()
                Button { showingEditor = true } label: {
                    Image(systemName: "plus")
                }
            }
            LazyVGrid(
                columns: [.init(.adaptive(minimum: 80, maximum: 150), spacing: 20)],
                alignment: .leading,
                spacing: 20
            ) {
                ForEach(appState.bookmarks) { item in
                    BookmarkItem(bookmark: item)
                }
            }
        }
        .sheet(isPresented: $showingEditor) {
            BookmarkEditor(editing: $showingEditor, original: nil)
        }
    }
}

private struct BookmarkItem: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var showingEditor = false
    
    let bookmark: Bookmark
    
    var body: some View {
        VStack {
            KFImage(URL(string: bookmark.icon))
                .resizable()
                .frame(width: 24, height: 24)
            Text(bookmark.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer(minLength: 0)
        }
        .frame(width: 80)
        .frame(height: 64)
        .contextMenu {
            MenuItem("Edit (E)", icon: "pencil", key: "E", action: edit)
            MenuItem("Delete (E)", icon: "trash", key: "D", action: delete)
            MenuItem("Visit (E)", icon: "return", key: "V", action: visit)
        }
        .onTapGesture(perform: visit)
        .sheet(isPresented: $showingEditor) {
            BookmarkEditor(editing: $showingEditor, original: bookmark)
        }
    }
    
    func visit() {
        withAnimation {
            appState.showHome = false
            appState.navigationRequest = .urlString(urlString: bookmark.url)
        }
    }
    
    func edit() {
        withAnimation {
            showingEditor = true
        }
    }
    
    func delete() {
        withAnimation {
            appState.bookmarks.removeAll { $0.id == bookmark.id }
        }
    }
}

struct MenuItem: View {
    
    let title: String
    let icon: String
    let action: () -> Void
    let shortcut: KeyboardShortcut
    
    init(
        _ title: String,
        icon: String = "",
        shortcut: KeyboardShortcut,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.shortcut = shortcut
        self.action = action
    }
    
    init(
        _ title: String,
        icon: String = "",
        key: KeyEquivalent,
        action: @escaping () -> Void
    ) {
        self.init(title, icon: icon, shortcut: .init(key), action: action)
    }
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
        }
        .keyboardShortcut(shortcut)
    }
}
