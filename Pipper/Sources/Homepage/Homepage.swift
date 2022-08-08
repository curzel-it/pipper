//
//  Homepage.swift
//  Pipper
//
//  Created by Federico Curzel on 30/07/22.
//

import SwiftUI

struct Homepage: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BookmarksGrid()
            }
            .padding()
        }
    }
}
