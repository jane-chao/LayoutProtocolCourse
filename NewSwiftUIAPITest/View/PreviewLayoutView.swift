//
//  PreviewLayoutView.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/15.
//

import SwiftUI



struct PreviewLayoutView<Layout: View>: View {
    var title: String
    var tabImage: String
    var layout: () -> Layout
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(.accentColor)
                .font(.title2.bold())
                .padding(.vertical)
            layout()
            
        }.tabItem { Image(systemName: tabImage) }
            
    }
}
