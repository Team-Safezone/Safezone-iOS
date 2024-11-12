//
//  PredictionPlayerView.swift
//  KickIt
//
//  Created by 이윤지 on 9/17/24.
//

import SwiftUI

/// 선발라인업 예측 바텀 시트에 들어갈 선수 뷰
struct PredictionPlayerView: View {
    /// 선수 객체
    var player: StartingLineupPlayer
    
    /// 선수 선택 여부
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // 선수 프로필 사진
            LoadableImage(image: player.playerImgURL)
                .frame(width: 80, height: 80)
                .background(.whiteAssets)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .fill(isSelected ? .blackAssets : .clear)
                        .opacity(isSelected ? 0.5 : 0)
                )
            
            // 선수 등번호 및 이름
            Text("\(player.backNum). \(player.playerName)")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(isSelected ? .gray500 : .white0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview("선수 선택 뷰") {
    PredictionPlayerView(player: StartingLineupPlayer(playerImgURL: "", playerName: "손흥민", backNum: 7, playerPosition: 4), isSelected: true)
}
