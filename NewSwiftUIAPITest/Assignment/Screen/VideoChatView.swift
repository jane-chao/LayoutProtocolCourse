//
//  VideoChatView.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

struct VideoChatView: View {
    @State private var visibility: [VideoChatLayout.Visibility]
    @State private var showParticipants: Bool = false
    
    private var title: String
    private var participants: [PetProfile]
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
            ScrollView {
                VideoChatLayout {
                    ForEach(participants.indices, id: \.self) { index in
                        VideoChatImage(participants[index],
                                       visibility: $visibility[index])
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(title)
            .toolbar {
                Button("名單") { showParticipants.toggle() }.bold()
            }
            .sheet(isPresented: $showParticipants) {
                VideoParticipantsView(visibility: $visibility, participants: participants)
                    .presentationDetents([.medium, .large])
            }
            .animation(.easeInOut, value: visibility)
            .task {
                guard !visibility.isEmpty else { return }
                visibility[0] = .pinned
            }
        }
    }
}


extension VideoChatView {
    init(title: String, participants: [PetProfile]) {
        self.title = title
        self.participants = participants
        _visibility = .init(wrappedValue: .init(repeating: .normal,
                                                count: participants.count))
    }
    
    init(title: String, mockPeopleCount: Int) {
        let count = min(mockPeopleCount, Constant.puppies.count)
        self.title = title
        self.participants = Array(Constant.puppies.shuffled().prefix(count))
        _visibility = .init(wrappedValue: .init(repeating: .normal,
                                                count: count))
        
    }
}



struct VideoChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VideoChatView(title: "快樂聊天室",
                          participants: Array(Constant.puppies[0...4]))
        }
    }
}
