//
//  Shadow+.swift
//  KickIt
//
//  Created by 이윤지 on 9/29/24.
//

import SwiftUI

/// 커스텀 그림자 확장 함수 파일
extension View {
    /// 기본 그림자
    func defaultShadow() -> some View {
        self.shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
    /// 카드 그림자
    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
    }
    
    /// 엠블럼 그림자
    func emblemShadow() -> some View {
        self.shadow(color: .black.opacity(0.15), radius: 2, x: 3, y: 3)
    }
}
