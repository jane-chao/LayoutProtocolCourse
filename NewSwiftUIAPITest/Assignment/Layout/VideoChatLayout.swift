//
//  VideoChatLayout.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

// TODO: 2️⃣ 設計 Layout：會先排 pinned 的 view，用最寬大小顯示，接著排 normal view，它會是方形的，一排"最多"顯示三個，超過換行。hidden 的 view 則不顯示。
struct VideoChatLayout {
    
}


// TODO: 1️⃣ 讓這個 enum 能被 Layout 讀取
extension VideoChatLayout {
    enum Visibility {
        case pinned, normal, hidden
    }
}
