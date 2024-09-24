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
    let tracking: CGFloat
    let uiFont: UIFont // 행간을 위한 상수
    let lineHeight: CGFloat // 행간
    
    init(font: Font, tracking: CGFloat, uiFont: UIFont, lineHeight: CGFloat) {
        self.font = font
        self.tracking = tracking
        self.uiFont = uiFont
        self.lineHeight = lineHeight
    }
    
    static let H1Style = TextStyle(font: .H1, tracking: 0, uiFont: UIFont(name: "Pretendard-Bold", size: 24)!, lineHeight: 30)
    static let H2Style = TextStyle(font: .H2, tracking: 0, uiFont: UIFont(name: "Pretendard-Bold", size: 20)!, lineHeight: 26)
    static let Title1Style = TextStyle(font: .Title1, tracking: -0.4, uiFont: UIFont(name: "Pretendard-Bold", size: 18)!, lineHeight: 24)
    static let Title2Style = TextStyle(font: .Title2, tracking: -0.4, uiFont: UIFont(name: "Pretendard-Bold", size: 16)!, lineHeight: 24)
    static let SubTitleStyle = TextStyle(font: .SubTitle, tracking: 0, uiFont: UIFont(name: "Pretendard-SemiBold", size: 14)!, lineHeight: 20)
    static let Body1Style = TextStyle(font: .Body1, tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 16)!, lineHeight: 24)
    static let Body2Style = TextStyle(font: .Body2, tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 14)!, lineHeight: 20)
    static let Body3Style = TextStyle(font: .Body3, tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 14)!, lineHeight: 20)
    static let Caption1Style = TextStyle(font: .Caption1, tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 12)!, lineHeight: 18)
    static let Caption2Style = TextStyle(font: .Caption2, tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 12)!, lineHeight: 18)
}

struct PretendardTextModifier: ViewModifier {
    let textStyle: TextStyle
    
    func body(content: Content) -> some View {
        let fontSpacing = (textStyle.lineHeight - textStyle.uiFont.lineHeight) / 4
        return content
            .font(textStyle.font)
            .tracking(textStyle.tracking)
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
    }
}

extension View {
    /// letter spacing + pretnedard font 확장 함수
    func pretendardTextStyle(_ style: TextStyle) -> some View {
        self.modifier(PretendardTextModifier(textStyle: style))
    }
}
