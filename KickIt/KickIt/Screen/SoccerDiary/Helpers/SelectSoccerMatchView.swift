//
//  SelectSoccerMatchView.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import SwiftUI

/// 축구 일기에서 사용하는 경기 리스트 뷰
struct SelectSoccerMatchView: View {
    /// 경기 객체
    var match: SelectSoccerMatch
    
    var body: some View {
        HStack(spacing: 0) {
            // MARK: 홈팀
            HStack(spacing: 4) {
                LoadableImage(image: match.homeTeamEmblemURL)
                    .frame(width: 28, height: 28)
                
                Text(match.homeTeamName)
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray200Assets)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(convertScore(score: match.homeTeamScore ?? -1))
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
            
            Text(match.matchTime)
                .pretendardTextStyle(.Body1Style)
                .foregroundStyle(.gray200Assets)
                .padding(.horizontal, 24)
            
            // MARK: 원정팀
            Text(convertScore(score: match.awayTeamScore ?? -1))
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
            
            HStack(spacing: 4) {
                Text(match.awayTeamName)
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray200Assets)
                
                LoadableImage(image: match.awayTeamEmblemURL)
                    .frame(width: 28, height: 28)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray950)
        )
    }
    
    /// 점수를 string으로 바꾸는 함수
    private func convertScore(score: Int) -> String {
        if score != -1 {
            return "\(score)"
        }
        else {
            return "-"
        }
    }
}

#Preview {
    SelectSoccerMatchView(match: dummySelectSoccerMatch)
}
