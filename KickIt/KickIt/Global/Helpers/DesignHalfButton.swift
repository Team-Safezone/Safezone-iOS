//
//  DesignHalfButton.swift
//  KickIt
//
//  Created by 이윤지 on 5/26/24.
//

import SwiftUI

/// 절반 사이즈의 버튼 뷰
struct DesignHalfButton: View {
    /// 버튼 안의 텍스트
    var label: String
        
    /// 버튼 안의 텍스트 색상
    var labelColor: Color
    
    /// 버튼 배경 색상
    var btnBGColor: Color
    
    /// 우측 이모지
    var img: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(label)")
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(labelColor)
            
            // 우측 이미지가 있다면 배치하기
            if img != nil {
                Image(systemName: img!)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(labelColor)
                    .padding(.leading, 8)
            }
        }
        .padding([.top, .bottom], 15)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(btnBGColor)
        )
    }
}

#Preview {
    DesignHalfButton(label: "다음 예측하기", labelColor: .white, btnBGColor: .gray600, img: "arrow.right")
}
