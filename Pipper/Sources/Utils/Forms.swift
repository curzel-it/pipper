import Schwifty
import SwiftUI

struct FormField<Content: View>: View {    
    let title: String
    var titleWidth: CGFloat = 150
    let contentWidth: CGFloat = 250
    var hint: String? = nil
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 16) {
                Text(title)
                    .textAlign(.leading)
                    .frame(width: titleWidth)
                content()
                    .frame(width: contentWidth)
            }
            if let hint {
                Text(hint)
                    .font(.caption)
                    .textAlign(.leading)
            }
        }
        .frame(width: titleWidth + 16 + contentWidth)
    }
}
