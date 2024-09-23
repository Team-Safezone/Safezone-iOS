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
            VStack(alignment: .leading, spacing: 8) {
                Text(formation)
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.white0)
                
                Text(formationType)
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray500Down)
            }
            Spacer()
            HStack(spacing: 4) {
                ForEach(formationIcons, id: \.self) { icon in
                    Image(uiImage: icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.gray500Down)
                }
            }
        }
        .padding(16)
    }
}

#Preview("축구 팀 포메이션 Row") {
    FormationRowView(formation: "4-3-3 포메이션", formationType: "공격형", formationIcons: [.soccerBall])
}
