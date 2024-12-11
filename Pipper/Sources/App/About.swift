import Schwifty
import SwiftUI

struct AboutView: View {
    var body: some View {
        HStack(spacing: .lg) {
            Socials()
            PrivacyPolicy()
            AppVersion()
            Spacer()
        }
    }
}

private struct AppVersion: View {
    @EnvironmentObject var appState: AppState
        
    var text: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dev = isDevApp ? "Dev" : ""
        return ["v.", version ?? "n/a", dev]
            .filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var isDevApp: Bool {
        let bundle = Bundle.main.bundleIdentifier ?? ""
        return bundle.contains(".dev")
    }
    
    var body: some View {
        Text(text)
    }
}

private struct PrivacyPolicy: View {
    var body: some View {
        Button("Privacy Policy") {
            URL.visit(urlString: "https://curzel.it/privacy")
        }
        .buttonStyle(.link)
    }
}

private struct Socials: View {
    var body: some View {
        HStack(spacing: .sm) {
            SocialIcon(name: "github", link: "https://github.com/curzel-it/pipper")
            SocialIcon(name: "twitter", link: "https://x.com/@HiddenMugs")
            SocialIcon(name: "youtube", link: "https://www.youtube.com/@HiddenMugs")
            SocialIcon(name: "sneakbit", link: "https://curzel.it/sneakbit")
        }
    }
}

private struct SocialIcon: View {
    let name: String
    let link: String
    
    var body: some View {
        Image(name)
            .resizable()
            .antialiased(true)
            .frame(width: 24, height: 24)
            .onTapGesture { URL.visit(urlString: link) }
    }
}
