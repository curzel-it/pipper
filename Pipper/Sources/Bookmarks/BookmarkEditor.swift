import Combine
import Schwifty
import SwiftUI

struct BookmarkEditor: View {
    @StateObject private var viewModel: BookmarkEditorViewModel
        
    init(editing: Binding<Bool>, original: Bookmark?) {
        _viewModel = StateObject(
            wrappedValue: BookmarkEditorViewModel(editing: editing, bookmark: original)
        )
    }
    
    var body: some View {
        VStack {
            Text(viewModel.viewTitle)
                .font(.title.bold())
                .positioned(.leading)
                .padding(.bottom, 8)
            
            FormField(title: "Title", titleWidth: 50) { TextField("", text: $viewModel.title) }
            FormField(title: "URL", titleWidth: 50) { TextField("", text: $viewModel.url) }
            FormField(title: "Icon", titleWidth: 50) { TextField("", text: $viewModel.icon) }
                .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Button("Close", action: viewModel.close).keyboardShortcut(.cancelAction)
                Button("Save", action: viewModel.save).keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .onSubmit(viewModel.save)
    }
}

private class BookmarkEditorViewModel: ObservableObject {
    @Published var viewTitle: String
    @Published var url: String
    @Published var title: String
    @Published var icon: String
    
    @Inject private var appState: AppState
    
    private let id: String
    private var editing: Binding<Bool>
    private var disposables = Set<AnyCancellable>()
    
    init(editing: Binding<Bool>, bookmark: Bookmark?) {
        self.editing = editing
        
        id = bookmark?.id ?? UUID().uuidString
        title = bookmark?.title ?? ""
        url = bookmark?.url ?? ""
        icon = bookmark?.icon ?? ""
        viewTitle = bookmark.let { "Edit '\($0.title)'" } ?? "New Bookmark"
        
        bindIconToUrl()
    }
    
    func close() {
        withAnimation {
            editing.wrappedValue = false
        }
    }
    
    func bindIconToUrl() {
        $url
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newUrl in self?.updateIcon(fromUrl: newUrl) }
            .store(in: &disposables)
    }
    
    private func updateIcon(fromUrl urlString: String) {
        let fixedUrlString = urlString.hasPrefix("http") ? urlString : "https://\(urlString)"
        guard let url = URL(string: fixedUrlString) else { return }
        let scheme = url.scheme ?? "https"
        
        let host = if #available(macOS 13.0, *) {
            url.host()
        } else {
            url.host
        }
        guard let host else { return }
        icon = "\(scheme)://\(host)/favicon.ico"
    }
     
    func save() {
        let item = Bookmark(id: id, title: title, url: url, icon: icon)
        withAnimation {
            appState.add(bookmark: item)
            editing.wrappedValue = false
            appState.userMessage = UserMessage(
                text: "'\(title)' added to your bookmarks",
                duracy: .short,
                severity: .success
            )
        }
    }
}
