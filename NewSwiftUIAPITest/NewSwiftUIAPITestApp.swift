//
//  NewSwiftUIAPITestApp.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/07.
//

import SwiftUI

@main
struct NewSwiftUIAPITestApp: App {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
    }
    
    var body: some Scene {
        WindowGroup {
            VideoChatMainScreen()
        }
    }
}
