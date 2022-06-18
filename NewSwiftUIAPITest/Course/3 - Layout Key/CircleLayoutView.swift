//
//  CircleLayout.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/14.
//

import SwiftUI


struct OffsetKey: LayoutValueKey {
    static var defaultValue: CGFloat = 0
}

enum ClockPosition: Double, LayoutValueKey, CaseIterable, CustomStringConvertible {
    
    static var defaultValue = Self.twelve
    
    case twelve, one, two, three, four, five
    case six, seven, eight, nine, ten, eleven
    
    var description: String {
        let clock = rawValue == 0 ? 12 : Int(rawValue)
        return clock.description
    }
}

extension View {
    func clock(at position: ClockPosition) -> some View {
        layoutValue(key: ClockPosition.self, value: position)
    }
}


struct CircleLayout: Layout {
    
    static let angle = Angle.degrees(360 / 12).radians
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let minSide = min(bounds.size.width, bounds.size.height)
        let radius = minSide / 2
        
        
        subviews.forEach { view in
            let size = view.sizeThatFits(.unspecified)
            let offset = view[OffsetKey.self] * 0.1
            let clockPosition = view[ClockPosition.self]
            var point = CGPoint(x: 0, y: -radius * (1 + offset))
                .applying(CGAffineTransform(rotationAngle: Self.angle * clockPosition.rawValue))
            
            point.x += bounds.midX
            point.y += bounds.midY
            
            view.place(at: point, anchor: .center, proposal: .init(size))
        }
    }
}


struct CircleLayoutView: View {
    @State var distance: CGFloat = 0
    @State var positions: [ClockPosition] = [.twelve, .three, .seven]
    
    var body: some View {
        ScrollView {
            CircleLayout {
                ForEach(Constant.heroes.indices, id: \.self) { index in
                    Image(Constant.heroes[index])
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .clipShape(Circle())
                        .layoutValue(key: OffsetKey.self, value: distance)
                        .clock(at: positions[index])
                }
            }
            .background(Circle().fill(.teal.gradient.opacity(0.8)))
            .frame(width: UIScreen.main.bounds.width, height: 300)
            .padding(.vertical, 50)
                
            HStack {
                Text("距離").font(.title3)
                Slider(value: $distance, in: -10...10)
                Text(Int(distance).description).font(.title)
            }.frame(width: UIScreen.main.bounds.width * 0.7)
            
            ForEach(positions.indices, id: \.self) { index in
                Text("\(Constant.heroes[index]) 在 \(positions[index].description) 點鐘方向")
                    .font(.title3)
                    .padding(.vertical, 10)
            }
    
            Button("換位置") {
                positions = ClockPosition.allCases.shuffled().suffix(3)
            }.font(.title3).buttonStyle(.bordered).padding()
            
        }.animation(.easeInOut, value: positions)
    }
}

struct CircleLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLayoutView()
    }
}
