//
//  FormationRowView.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 축구 팀 포메이션 Row View
struct FormationRowView: View {
    /// 포메이션
    var formation: String
    
    /// 포메이션 유형
    var formationType: String
    
    /// 포메이션 이미지 리스트
    var formationIcons: [UIImage]
    
    var body: some View {
        HStack {
            Text(formation)
                .pretendardTextStyle(.Body1Style)
                .foregroundStyle(.white0)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(formationType)
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray500Text)
                
                HStack(spacing: 1) {
                    Image(uiImage: formationIcons[0])
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray500Text)
                        .frame(width: 5, height: 1)
                    
                    Image(uiImage: formationIcons[1])
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
    }
}

#Preview("축구 팀 포메이션 Row") {
    FormationRowView(formation: "4-3-3 포메이션", formationType: "공격형", formationIcons: [.fireball, .fireball])
}
