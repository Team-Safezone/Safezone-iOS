//
//  DesignButton.swift
//  KickIt
//
//  Created by DaeunLee on 5/16/24.
//

import SwiftUI

/// 와이드 버튼 뷰
struct DesignWideButton: View {
    /// 버튼 안의 텍스트
    var label: String
        
    /// 버튼 안의 텍스트 색상
    var labelColor: Color
    
    /// 버튼 배경 색상
    var btnBGColor: Color
    
    var body: some View {
        Text("\(label)")
            .pretendardTextStyle(.Title1Style)
            .foregroundStyle(labelColor)
            .padding([.top, .bottom], 15)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(btnBGColor)
            )
            .padding([.leading, .trailing], 16)
    }
}

#Preview {
    DesignWideButton(label: "참여하기", labelColor: .white, btnBGColor: .gray600)
}
