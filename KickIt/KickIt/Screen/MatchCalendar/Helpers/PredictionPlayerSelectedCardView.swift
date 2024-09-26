//
//  PredictionPlayerSelectedCardView.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 선발라인업 예측 화면에서 사용되는 선수 선택 완료 카드 뷰
struct PredictionPlayerSelectedCardView: View {
    /// 선수 객체
    var player: StartingLineupPlayer
    
    var body: some View {
        VStack(spacing: 2) {
            // 선수 프로필 사진
            LoadableImage(image: player.playerImgURL)
                .frame(width: 40, height: 40)
                .background(.whiteAssets)
                .clipShape(Circle())
            
            // 선수 등번호 및 이름
            Text("\(player.backNum). \(player.playerName)")
                .pretendardTextStyle(.Caption1Style)
                .foregroundStyle(.white0)
        }
        .frame(width: 54, height: 60)
    }
}

#Preview("선수 선택 완료 카드 뷰") {
    PredictionPlayerSelectedCardView(player: StartingLineupPlayer(playerImgURL: "", playerName: "손흥민", backNum: 7, playerPosition: 4))
}
