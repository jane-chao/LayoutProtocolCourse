//
//  TextButton.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/18.
//

import SwiftUI

struct TextButton: View {
    var text: String
    
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Button {
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}
