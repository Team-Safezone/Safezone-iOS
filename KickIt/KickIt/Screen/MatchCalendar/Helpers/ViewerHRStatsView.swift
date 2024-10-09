//
//  ViewerHRStatsView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

/// 심박수 통계 화면의 심박수 비교 표(홈팀, 원정팀의 최저, 평균, 최고 심박수 비교)
struct ViewerHRStatsView: View {
    // 홈팀 심박수 배열
    var homeTeamStats: [Int?]
    
    // 원정팀 심박수 배열
    var awayTeamStats: [Int?]
    
    /// 홈팀 이름
    var homeTeamName: String
    
    /// 원정팀 이름
    var awayTeamName: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text("심박수 비교")
                .pretendardTextStyle(.Title2Style)
        VStack{
            HStack {
                HStack{
                    Text(homeTeamName + " 팬")
                        .pretendardTextStyle(.SubTitleStyle)
                        .frame(width: 80)
                }
                Spacer().frame(width: 100)
                Text(awayTeamName + " 팬")
                    .pretendardTextStyle(.SubTitleStyle)
                    .frame(width: 80)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background {
                SpecificRoundedRectangle(radius: 8, corners: [.topRight, .topLeft])
                    .foregroundStyle(Color.gray950Assets)
                    .frame(width: 355, height: 55)
            }
            
            ForEach(0..<3, id: \.self) { i in
                HStack {
                    HStack(spacing: 2) {
                        Text("\(homeTeamStats[i] ?? 0)")
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.white0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray800Assets)
                    }
                    .frame(width: 80)
                    
                    Text(i == 0 ? "최저" : i == 1 ? "평균" : "최고")
                        .pretendardTextStyle(.Body2Style)
                        .frame(width: 100)
                        .foregroundStyle(.white0)
                    
                    HStack(spacing: 2) {
                        Text("\(awayTeamStats[i] ?? 0)")
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.white0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray800Assets)
                    }
                    .frame(width: 80)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray900Assets, lineWidth: 1)
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115))
                path.addLine(to: CGPoint(x: 355, y: 115))
            }
            .stroke(.gray900Assets, style: StrokeStyle(lineWidth: 1))
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115 + 115 / 2))
                path.addLine(to: CGPoint(x: 355, y: 115 + 115 / 2))
            }
            .stroke(.gray900Assets, style: StrokeStyle(lineWidth: 1))
        }
    }
    }
}

#Preview {
    ViewerHRStatsView(homeTeamStats: [1,2,3], awayTeamStats: [1,2,3], homeTeamName: "토트넘", awayTeamName: "아스널")
}
