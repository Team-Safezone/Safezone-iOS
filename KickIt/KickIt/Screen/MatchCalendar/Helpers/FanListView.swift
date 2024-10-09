//
//  FanListView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

/// 심박수 통계 화면의 심박수 그래프의 하단 정보 뷰
struct FanListView: View {
    var homeTeamName: String // 홈팀 이름
    var awayTeamName: String // 원정팀 이름
    
    var body: some View {
        HStack(spacing: 44) {
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text("나")
                    .font(.pretendard(.medium, size: 14))
            }
            .foregroundStyle(.limeText)
            
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text(homeTeamName + " 팬")
                    .font(.pretendard(.medium, size: 14))
            }
            .foregroundStyle(.green0)
            
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text(awayTeamName + " 팬")
                    .font(.pretendard(.medium, size: 14))
            }
            .foregroundStyle(.violet)
        }
        .padding(.top, 31)
        .padding(.bottom, 40)
    }
}

#Preview {
    FanListView(homeTeamName: "토트넘", awayTeamName: "아스널")
}
