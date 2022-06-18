//
//  MockRoomRouter.swift
//  NewSwiftUIAPITest
//
//  Created by Jane Chao on 22/06/17.
//


enum MockRoomRouter: String, CaseIterable {
    case 一對一談心, 三人房, 四人房, 五人房, 十人房, 大家都來聊
    
    var people: Int {
        switch self {
            case .一對一談心: return 2
            case .三人房: return 3
            case .四人房: return 4
            case .五人房: return 5
            case .十人房: return 10
            case .大家都來聊: return Constant.puppies.count
        }
    }
    
    var title: String {
        "\(emoji) \(rawValue)"
    }
    
    private var emoji: String {
        switch self {
            case .一對一談心:
                return "💕"
            case .三人房:
                return "👩‍👦‍👦"
            case .四人房:
                return "👨‍👩‍👧‍👧"
            case .五人房:
                return "🖐"
            case .十人房:
                return "🚌"
            case .大家都來聊:
                return "🎈"
        }
    }
}
