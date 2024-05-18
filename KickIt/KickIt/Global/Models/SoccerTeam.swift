//
//  SoccerTeam.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import Foundation

/// 축구 팀 모델
struct SoccerTeam: Identifiable {
    var id = UUID().uuidString // 고유 id
    var teamImgURL: String // 팀 로고 이미지
    var teamName: String // 팀 이름
}
