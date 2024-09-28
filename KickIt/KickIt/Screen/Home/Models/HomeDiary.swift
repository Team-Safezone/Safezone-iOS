//
//  HomeDiary.swift
//  KickIt
//
//  Created by 이윤지 on 9/28/24.
//

import Foundation

/// [Entity] 홈 화면에서 축구 일기 쓰기 버튼 클릭 시 사용할 모델
struct HomeDiary {
    let diaryId: Int64 // 축구 일기 id
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeam: SoccerTeam // 홈팀
    var awayTeam: SoccerTeam // 원정티
}
