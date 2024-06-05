//
//  VerticalBarChart.swift
//  KickIt
//
//  Created by 이윤지 on 5/26/24.
//

import SwiftUI

/// 우승팀 예측하기 가로 막대 그래프
struct VerticalBarChart: View {
    /// 막대 그래프에 들어갈 데이터
    let data: [(String, Double)]
    
    var body: some View {
        // 가장 높은 퍼센트 값을 가진 데이터 찾기
        let highPercentData = data.max(by: { $0.1 < $1.1 })?.1 ?? 0
        
        VStack(alignment: .leading, spacing: 8) {
            ForEach(data, id: \.0) { chart in
                ZStack(alignment: .leading) {
                    // MARK: 막대그래프 배경
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray50)
                        .frame(maxWidth: .infinity, maxHeight: 51)
                    
                    // MARK: 투표율 막대그래프
                    RoundedRectangle(cornerRadius: 8)
                        .fill(chart.1 == highPercentData ? .gray600 : .gray400)
                        .frame(width: CGFloat(chart.1) * 3, height: 51)
                    
                    // MARK: 그래프 이름
                    Text(chart.0)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Int(chart.1) > 5 ? .white : .gray600)
                        .padding(.leading, 20)
                    
                    // MARK: 퍼센트 정보
                    Text("\(Int(chart.1))%")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Int(chart.1) > 95 ? .white : .gray600)
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}

//#Preview {
//    VerticalBarChart(data: [
//        (soccerMatch.homeTeam.teamName, 30.0),
//        (soccerMatch.awayTeam.teamName, 65.0),
//        ("무승부", 5.0)
//    ])
//}
