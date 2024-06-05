//
//  DesignChip.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import SwiftUI

/// 디자인 시스템 - chips
struct DesignChip: ButtonStyle {
    /// 텍스트 색상
    var labelColor: Color
    
    /// 칩 배경 색상
    var labelBGColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(labelBGColor)
            
            configuration.label
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(labelColor)
        }
    }
}
