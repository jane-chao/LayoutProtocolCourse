//
//  ColumnFlowLayout.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/13.
//
import SwiftUI

struct ColumnFlowLayout: Layout {
    var columns: Int = 3
    var hSpacing: CGFloat = 10
    var vSpacing: CGFloat = 10
    
    struct Column {
        var viewSizes: [CGSize] = []
    }
    
    private func getColumnWidth(totalWidth: CGFloat?) -> CGFloat? {
        guard let totalWidth else { return nil }
        return ((totalWidth + hSpacing) / CGFloat(columns)) - hSpacing
    }
    
    private func makeColumns(subviews: Subviews, columnWidth: CGFloat) -> [Column] {
        let proposal = ProposedViewSize(width: columnWidth, height: nil)
        var allColumns: [Column] = .init(repeating: .init(), count: columns)
        
        subviews.enumerated().forEach { index, view in
            let size = view.sizeThatFits(proposal)
            allColumns[index % columns].viewSizes.append(size)
        }
        
        return allColumns
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let columnWidth = getColumnWidth(totalWidth: proposal.width), !subviews.isEmpty else {
            return .zero
        }
        
        let allColumns = makeColumns(subviews: subviews, columnWidth: columnWidth)
        
        let maxColumnHeight = allColumns.reduce(CGFloat.zero) { maxHeight, eachColumn in
            let columnTotalHeight = eachColumn.viewSizes.map(\.height).reduce(0, +)
            let spacing = CGFloat(eachColumn.viewSizes.count - 1) * vSpacing
            return max(maxHeight, columnTotalHeight + spacing)
        }
        
        return .init(width: (columnWidth + hSpacing) * CGFloat(columns) - hSpacing,
                     height: maxColumnHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard let columnWidth = getColumnWidth(totalWidth: proposal.width) else { return }
        let allColumns = makeColumns(subviews: subviews, columnWidth: columnWidth)
        
        var x = bounds.minX
        var y = bounds.minY
        
        allColumns.enumerated().forEach { columnIndex, column in
            let viewSizes = column.viewSizes
            var subviewIndex = columnIndex
            
            viewSizes.forEach { viewSize in
                let view = subviews[subviewIndex]
                defer { subviewIndex += columns }
                
                view.place(at: .init(x: x,
                                     y: y),
                           proposal: .init(viewSize))
                y += viewSize.height + vSpacing
            }
            
            x += columnWidth + hSpacing
            y = bounds.minY
        }
    }
}


struct ColumnFlowLayoutView: View {
    var body: some View {
        ScrollView {
            ColumnFlowLayout(columns: 3, hSpacing: 15  , vSpacing: 15)() {
                ForEach(Constant.images, id: \.self) { image in
                    Image(image)
                        .resizable().aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }.padding()
    }
}


struct ColumnFlowLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnFlowLayoutView()
    }
}
