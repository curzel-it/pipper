import Schwifty
import SwiftUI

struct FormField<Content: View>: View {    
    let title: String
    var titleWidth: CGFloat = 150
    let content: () -> Content
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Text(title)
            }
            .frame(width: titleWidth)
            content()
                .frame(maxWidth: 250)
        }
    }
}
