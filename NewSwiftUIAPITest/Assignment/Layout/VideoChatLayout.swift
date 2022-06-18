//
//  VideoChatLayout.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//

import SwiftUI

struct VideoChatLayout: Layout {
    let spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let totalWidth = proposal.width else { return .zero }
        
        let groupedViews = Dictionary.init(grouping: subviews, by: \.visibility)
        var layoutSize: CGSize = .zero
        
        groupedViews[.pinned]?.forEach { view in
            let size = view.sizeThatFits(.init(width: totalWidth, height: nil))
            layoutSize.append(size, on: .vertical, spacing: 10)
        }
        
        let normalLayoutInfo = getSplitSizing(width: totalWidth,
                                              viewCount: groupedViews[.normal]?.count ?? 0)
        
        layoutSize.append(normalLayoutInfo.layoutSize,
                          on: .vertical,
                          spacing: spacing)
        
        return layoutSize
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let groupedViews = Dictionary.init(grouping: subviews, by: \.visibility)
        let normalWidth = getSplitSizing(width: bounds.width,
                                         viewCount: groupedViews[.normal]?.count ?? 0).sideLength
        
        let pinnedProposal = ProposedViewSize(width: bounds.width, height: nil)
        let normalProposal = ProposedViewSize(width: normalWidth, height: normalWidth)
        
        var x = bounds.minX
        var y = bounds.minY
        
        groupedViews[.pinned]?.forEach { view in
            let size = view.sizeThatFits(pinnedProposal)
            view.place(at: .init(x: x, y: y),
                       proposal: .init(size))
            y += size.height + spacing
        }
        
        subviews.forEach { view in
            switch view.visibility {
                case .pinned:
                    break
                    
                case .normal:
                    view.place(at: .init(x: x, y: y),
                               proposal: normalProposal)
                    x += normalWidth + spacing
                    if x >= bounds.maxX {
                        x = bounds.minX
                        y += normalWidth + spacing
                    }
                    
                case .hidden:
                    view.place(at: bounds.origin, proposal: .zero)
            }
        }
    }
}

extension VideoChatLayout {
    enum Visibility: LayoutValueKey {
        static var defaultValue = Self.normal
        
        case pinned, normal, hidden
    }
    
    private func getSplitSizing(width: CGFloat, viewCount: Int) -> (sideLength: CGFloat, layoutSize: CGSize) {
        guard viewCount != 0 else { return (0, .zero) }
        
        let columns = min(3, CGFloat(viewCount))
        let rows = (CGFloat(viewCount) / columns).rounded(.up)
        let width = (width + spacing) / columns - spacing
        
        return (width,
                .init(width: (width + spacing) * columns - spacing,
                      height: (width + spacing) * rows - spacing))
    }
}

extension LayoutSubviews.Element {
    fileprivate var visibility: VideoChatLayout.Visibility { self[VideoChatLayout.Visibility.self] }
}

extension CGSize {
    mutating func append(_ other: CGSize, on axis: Axis, spacing: CGFloat = 0) {
        switch axis {
            case .horizontal:
                let spacing = width == .zero ? 0 : spacing
                self = .init(width: width + spacing + other.width,
                             height: max(height, other.height))
            case .vertical:
                let spacing = height == .zero ? 0 : spacing
                self = .init(width: max(width, other.width),
                             height: height + spacing + other.height)
        }
    }
}
