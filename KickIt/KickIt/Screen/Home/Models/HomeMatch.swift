//
//  HomeMatch.swift
//  KickIt
//
//  Created by 이윤지 on 9/28/24.
//

import Foundation

/// [Entity] 홈 화면의 우승팀 예측 버튼 클릭 시 사용할 모델
struct HomeMatch {
    let matchId: Int64 // 경기 id
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeam: SoccerTeam // 홈팀
    var awayTeam: SoccerTeam // 원정팀
}
