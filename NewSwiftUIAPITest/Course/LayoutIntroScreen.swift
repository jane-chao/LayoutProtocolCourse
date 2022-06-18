//
//  LayoutIntroScreen.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/15.
//

import SwiftUI

struct LayoutIntroScreen: View {
    var body: some View {
        TabView {
            PreviewLayoutView(title: "自動調整寬度", tabImage: "1.circle") {
                EqualSizeLayoutView()
            }
            PreviewLayoutView(title: "排到滿換行", tabImage: "2.circle") {
                FlowLayoutView()
            }
            PreviewLayoutView(title: "自訂 LayoutKey", tabImage: "3.circle") {
                CircleLayoutView()
            }
        }
    }
}


struct LayoutIntroView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutIntroScreen()
    }
}
