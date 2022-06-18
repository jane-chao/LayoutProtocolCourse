//
//  FlowLayoutView.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/10.
//

import SwiftUI

struct FlowLayout: Layout {
    var vSpacing: CGFloat = 10
    var alignment: TextAlignment = .leading
    
    struct Row {
        var viewRects: [CGRect] = []
        
        var width: CGFloat { viewRects.last?.maxX ?? 0 }
        var height: CGFloat { viewRects.map(\.height).max() ?? 0 }
        
        func getStartX(in bounds: CGRect, alignment: TextAlignment) -> CGFloat {
            switch alignment {
                case .leading:
                    return bounds.minX
                case .center:
                    return bounds.minX + (bounds.width - width) / 2
                case .trailing:
                    return bounds.maxX - width
            }
        }
    }
    
    
    private func getRows(subviews: Subviews, totalWidth: CGFloat?) -> [Row] {
        guard let totalWidth, !subviews.isEmpty else { return [] }
        
        var rows = [Row()]
        let proposal = ProposedViewSize(width: totalWidth, height: nil)
        
        subviews.enumerated().forEach { index, view in
            let size = view.sizeThatFits(proposal)
            let previousRect = rows.last!.viewRects.last ?? .zero
            let previousView = rows.last!.viewRects.isEmpty ? nil : subviews[index - 1]
            let spacing = previousView?.spacing.distance(to: view.spacing, along: .horizontal) ?? 0
            
            switch previousRect.maxX + spacing + size.width > totalWidth {
                case true:
                    let rect = CGRect(origin: .init(x: 0,
                                                    y: previousRect.minY + rows.last!.height + vSpacing), size: size)
                    rows.append(Row(viewRects: [rect]))
                case false:
                    let rect = CGRect(origin: .init(x: previousRect.maxX + spacing,
                                                    y: previousRect.minY),
                                      size: size)
                    rows[rows.count - 1].viewRects.append(rect)
            }
        }
        
        return rows
    }
    
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = getRows(subviews: subviews, totalWidth: proposal.width)
        
        
        return .init(width: rows.map(\.width).max() ?? 0,
                     height: rows.last?.viewRects.map(\.maxY).max() ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = getRows(subviews: subviews, totalWidth: bounds.width)
        var index = 0
        rows.forEach { row in
            let minX = row.getStartX(in: bounds, alignment: alignment)
            
            row.viewRects.forEach { rect in
                let view = subviews[index]
                defer { index += 1 }
                
                view.place(at: .init(x: rect.minX + minX,
                                     y: rect.minY + bounds.minY),
                           proposal: .init(rect.size))
                
            }
        }
    }
}


struct FlowLayoutView: View {
    @State var alignment: TextAlignment = .leading
    
    var body: some View {
        ScrollView {
            Picker("", selection: $alignment) {
                Text("向前").tag(TextAlignment.leading)
                Text("置中").tag(TextAlignment.center)
                Text("向後").tag(TextAlignment.trailing)
            }.pickerStyle(.segmented)
            
            FlowLayout(vSpacing: 15, alignment: alignment)() {
                ForEach(Constant.tags, id: \.self) { tag in
                    Button(tag) {}
                        .buttonStyle(.bordered)
                }

                Group {
                    Image("cat")
                       .resizable().aspectRatio(contentMode: .fit)
                   
                    ForEach(Constant.images, id: \.self) { image in
                        Image(image)
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(height: 110)
                    }
                }.clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .animation(.easeInOut, value: alignment)
            
        }
    }
}

struct FlowLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FlowLayoutView()
    }
}
