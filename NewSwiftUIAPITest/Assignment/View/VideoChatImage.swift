//
//  VideoChatImage.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

struct VideoChatImage: View {
    @Binding private var visibility: VideoChatLayout.Visibility
    private var pet: PetProfile
    
    init(_ pet: PetProfile, visibility: Binding<VideoChatLayout.Visibility>) {
        self.pet = pet
        _visibility = visibility
    }
    
    private var isPinned: Bool { visibility == .pinned }
    
    var body: some View {
        profileImage
            .contentShape(Rectangle())
            .contextMenu {
                Button("隱藏") {
                    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(isPinned ? 750 : 500))) {
                        visibility = .hidden
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .topTrailing) { pinButton }
            .overlay(alignment: .bottom) { nameLabel }
            .onTapGesture(count: 2, perform: togglePin)
    }
    
    // MARK: - subviews
    @ViewBuilder private var profileImage: some View {
        if isPinned {
            Image(pet.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color.clear
                .aspectRatio(1,contentMode: .fit)
                .overlay(
                    Image(pet.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
        }
    }
    
    private var pinButton: some View {
        Image(systemName: "pin.circle.fill")
            .imageScale(.large)
            .font(isPinned ? .title : .body)
            .foregroundStyle(.white, .black.gradient.opacity(0.4))
            .padding(3)
            .onTapGesture(perform: togglePin)
    }
    
    private var nameLabel: some View {
        Text(pet.name)
            .font((isPinned ? Font.title : .title3).weight(.medium))
            .foregroundColor(.white)
            .background(.black.gradient.opacity(0.8))
            .padding(.horizontal, isPinned ? 10 : 5)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(.bottom, isPinned ? 15 : 5)
    }
    
    // MARK: - Intents
    private func togglePin() {
        visibility = isPinned ? .normal : .pinned
    }
}



struct VideoChatImage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VideoChatImage(Constant.puppies[0],
                           visibility: .constant(.normal))
            VideoChatImage(Constant.puppies[0],
                           visibility: .constant(.pinned))
        }
    }
}
