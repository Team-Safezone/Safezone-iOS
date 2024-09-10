//
//  FanListView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

/// 심박수 통계 화면의 심박수 그래프의 하단 정보 뷰
struct FanListView: View {
    // !!!: 기존에는 뷰모델을 파라미터 값으로 받는 것으로 설정하셨더라고요. 그냥 경기 정보 화면(=SoccerMatchInfo.swift)에서 홈팀, 원정팀 이름만 가져오는 로직이 더 간단해 보여서 바꿨습니다!
    var homeTeamName: String // 홈팀 이름
    var awayTeamName: String // 원정팀 이름
    
    var body: some View {
        HStack(spacing: 44) {
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text("나")
                    .pretendardTextStyle(.Body2Style)
            }
            .foregroundStyle(.lime)
            
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text(homeTeamName + " 팬")
                    .pretendardTextStyle(.Body2Style)
            }
            .foregroundStyle(.green0)
            
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text(awayTeamName + " 팬")
                    .pretendardTextStyle(.Body2Style)
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
