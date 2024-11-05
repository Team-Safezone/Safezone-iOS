//
//  Font+.swift
//  KickIt
//
//  Created by 이윤지 on 6/2/24.
//

import SwiftUI

/// 커스텀 폰트를 관리하는 커스텀 폰트 파일
extension Font {
    enum Pretendard {
        case regular
        case medium
        case semibold
        case bold
        
        var value: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semibold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            }
        }
    }
    
    /// 커스텀 폰트 확장 함수
    static func pretendard(_ type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static let H1: Font = pretendard(.bold, size: 24)
    static let H2: Font = pretendard(.bold, size: 20)
    static let Title1: Font = pretendard(.bold, size: 18)
    static let Title2: Font = pretendard(.bold, size: 16)
    static let SubTitle: Font = pretendard(.semibold, size: 14)
    static let Body1: Font = pretendard(.medium, size: 16)
    static let Body2: Font = pretendard(.medium, size: 14)
    static let Body3: Font = pretendard(.medium, size: 13)
    static let Caption1: Font = pretendard(.medium, size: 12)
    static let Caption2: Font = pretendard(.medium, size: 10)
}
