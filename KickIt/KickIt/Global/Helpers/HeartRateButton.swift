//
//  HeartRateButton.swift
//  KickIt
//
//  Created by 이윤지 on 5/19/24.
//

import SwiftUI

/// 현재 심박수를 보여주고, 클릭 시 심박수 통계로 이동하는 버튼
struct HeartRateButton: View {
    /// 경기 객체
    @State var soccerMatch: SoccerMatch
    
    var body: some View {
        HStack(spacing: 4) {
            Image("Heartbeat")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.gray400)
            
            // 경기 중이라면
            if soccerMatch.matchCode == 1 {
                Text("160")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.gray600)
                
                Text("BPM")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray600)
            }
            // 경기가 종료됐다면
            else if soccerMatch.matchCode == 2 {
                Text("심박수 통계")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.gray600)
            }
            else {
                Text("다른 경기 시청 중")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray400)
            }
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 16)
        .background(
            RoundedRectangle(cornerRadius: 53)
                .fill(.white)
        )
    }
}

#Preview {
    HeartRateButton(soccerMatch: soccerMatches[0])
}
