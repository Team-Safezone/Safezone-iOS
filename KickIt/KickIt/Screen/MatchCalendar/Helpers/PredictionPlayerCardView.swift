//
//  PredictionPlayerView.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 선발라인업 예측 화면에서 사용되는 선수 선택 카드 뷰
struct PredictionPlayerCardView: View {
    // MARK: - PROPERTY
    /// 선수 포지션
    var playerPosition: Int
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Image(.plus)
                .frame(width: 24, height: 24)
                .foregroundStyle(.whiteAssets)
            
            Text(positionName(position: playerPosition))
                .pretendardTextStyle(.Caption2Style)
                .foregroundStyle(.whiteAssets)
        }
        .frame(width: 46, height: 54)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.black)
                .opacity(0.6)
        )
        .frame(width: 54, height: 60)
    }
    
    // MARK: - FUNCTION
    /// 선수 포지션 코드에 맞는 포지션 이름 반환 함수
    private func positionName(position: Int) -> String {
        switch position {
        case 1: return "골기퍼"
        case 2: return "수비수"
        case 3: return "미드필더"
        case 4: return "공격수"
        default: return "오류"
        }
    }
}

// MARK: - PREVIEW
#Preview("선수 선택 카드 뷰") {
    PredictionPlayerCardView(playerPosition: 2)
}
