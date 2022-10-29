import Foundation

extension URL {
    var favicon: URL? { Favicons.url(for: self) }
}

struct Favicons {
    static func url(for link: URL, size: Int = .defaultSize) -> URL? {
        guard let host = link.host else { return nil }
        return url(domain: host, size: size)
    }
    
    static func url(domain: String, size: Int = .defaultSize) -> URL? {
        let urlString = "https://www.google.com/s2/favicons?sz=\(size)&domain_url=\(domain)"
        return URL(string: urlString)
    }
}

private extension Int {
    static let defaultSize: Int = 64
}
