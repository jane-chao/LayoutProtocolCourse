//
//  VideoChatMainScreen.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

struct VideoChatMainScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(MockRoomRouter.allCases, id: \.self) { room in
                        NavigationLink(room.title, value: room)
                        
                    }
                } header: { Text("") }
            }
            .navigationTitle("ChaoCode 聊天室")
            .navigationDestination(for: MockRoomRouter.self) { room in
                VideoChatView(title: room.title, mockPeopleCount: room.people)
            }
        }
    }
}

struct VideoChatMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        VideoChatMainScreen()
    }
}
