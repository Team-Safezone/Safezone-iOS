//
//  TextStyle.swift
//  KickIt
//
//  Created by 이윤지 on 6/2/24.
//

import SwiftUI

/// 우리앱의 타이포그래피(커스텀 폰트 + 자간 + 행간)를 설정해둔 파일
struct TextStyle {
    let font: Font
    let lineSpacing: CGFloat
    let tracking: CGFloat
    
    init(font: Font, lineSpacing: CGFloat, tracking: CGFloat) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.tracking = tracking
    }
    
    static let H1Style = TextStyle(font: .H1, lineSpacing: 30, tracking: 0)
    static let H2Style = TextStyle(font: .H2, lineSpacing: 26, tracking: 0)
    static let Title1Style = TextStyle(font: .Title1, lineSpacing: 24, tracking: -4)
    static let Title2Style = TextStyle(font: .Title2, lineSpacing: 24, tracking: -4)
    static let SemiTitleStyle = TextStyle(font: .SemiTitle, lineSpacing: 20, tracking: 0)
    static let Body1Style = TextStyle(font: .Body1, lineSpacing: 24, tracking: 0)
    static let Body2Style = TextStyle(font: .Body2, lineSpacing: 20, tracking: 0)
    static let Body3Style = TextStyle(font: .Body3, lineSpacing: 20, tracking: 0)
    static let Caption1Style = TextStyle(font: .Caption1, lineSpacing: 18, tracking: 0)
    static let Caption2Style = TextStyle(font: .Caption2, lineSpacing: 18, tracking: 0)
}

struct PretendardTextModifier: ViewModifier {
    let textStyle: TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(textStyle.font)
            .lineSpacing(textStyle.lineSpacing)
            .tracking(textStyle.tracking)
    }
}

extension View {
    /// letter spacing + line height + pretnedard font 확장 함수
    func pretendardTextStyle(_ style: TextStyle) -> some View {
        self.modifier(PretendardTextModifier(textStyle: style))
    }
}
