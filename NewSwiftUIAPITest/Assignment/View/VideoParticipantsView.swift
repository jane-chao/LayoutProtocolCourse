//
//  VideoParticipantsView.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

struct VideoParticipantsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var visibility: [VideoChatLayout.Visibility]
    let participants: [PetProfile]

    var body: some View {
        NavigationStack {
            List {
                Section(header: Spacer(minLength: 0)) {
                    ForEach(visibility.indices, id: \.self) { index in
                        let shouldShowHiddenIcon = visibility[index] == .hidden
                        HStack {
                            Text(participants[index].name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button { setToVisitable(index: index) } label: {
                                Image(systemName: "eye.slash.fill")
                                    .opacity(shouldShowHiddenIcon ? 1 : 0)
                            }.disabled(!shouldShowHiddenIcon)
                        }
                    }
                }
            }
            .navigationBarTitle("參與者")
            .toolbar {
                ToolbarItem.init(placement: .navigationBarTrailing) {
                    Button("關閉") { dismiss() }
                }
            }
        }
    }
    
    private func setToVisitable(index: Int) {
        visibility[index] = .normal
    }
}


 
struct VideoParticipantsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoParticipantsView(visibility: .constant([.normal, .pinned, .hidden]),
                              participants: Array(Constant.puppies[...2]))
    }
}
