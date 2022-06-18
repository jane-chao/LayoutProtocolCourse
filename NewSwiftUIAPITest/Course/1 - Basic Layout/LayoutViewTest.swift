//
//  EqualSizeLayoutView.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/10.
//

import SwiftUI

struct EqualSizeLayout: Layout {
    var hSpacing: CGFloat = 10
    var vSpacing: CGFloat = 10
    
    private func getMaxSize(_ subviews: Subviews, totalWidth: CGFloat) -> CGSize {
        return subviews.reduce(.zero) { maxSize, view in
            let size = view.sizeThatFits(.unspecified)
            let idealSize = CGSize(width: max(maxSize.width, size.width),
                                   height: max(maxSize.height, size.height))
            return .init(width: min(idealSize.width, totalWidth), height: idealSize.height)
        }
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let totalWidth = proposal.width, !subviews.isEmpty else { return .zero }
        
        let maxSize = getMaxSize(subviews, totalWidth: totalWidth)
        
        let maxColumns = ((totalWidth + hSpacing) / (maxSize.width + hSpacing)).rounded(.down)
        let columns = min(maxColumns, CGFloat(subviews.count))
        let rows = (CGFloat(subviews.count) / columns).rounded(.up)
        
        let width = columns * (maxSize.width + hSpacing) - hSpacing
        let height = rows * (maxSize.height + vSpacing) - vSpacing
        
        return .init(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxSize = getMaxSize(subviews, totalWidth: bounds.width)
        let proposal = ProposedViewSize(maxSize)
        
        var x = bounds.minX
        var y = bounds.minY
        
        
        subviews.forEach { view in
            view.place(at: .init(x: x, y: y),
                       proposal: proposal)
            x += maxSize.width + hSpacing
            if (x >= bounds.maxX) {
                y += maxSize.height + vSpacing
                x = bounds.minX
            }
        }
    }
}



struct EqualSizeLayoutView: View {
    let tags = ["WWDC22", "SwiftUI", "Swift", "Apple", "iPhone", "iPad", "iOS"]
    
    var body: some View {
        ScrollView {
            EqualSizeLayout(hSpacing: 20, vSpacing: 20)() {
                ForEach(tags, id: \.self) { tag in
                        TextButton (tag)
                }
                //Image("cat").resizable().aspectRatio(contentMode: .fit)
            }
        }
        .padding()
    }
}

struct LayoutViewTest_Previews: PreviewProvider {
    static var previews: some View {
        EqualSizeLayoutView()
    }
}
