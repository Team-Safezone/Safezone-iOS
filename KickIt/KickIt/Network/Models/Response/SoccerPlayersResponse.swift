//
//  SoccerPlayersResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation

/// 선발라인업 화면에서 사용되는 선수 정보 Response 모델
struct SoccerPlayersResponse: Codable {
    var playerImgURL: String // 선수 이미지 URL
    var playerName: String // 선수 이름
    var playerNum: Int // 선수 등번호
}
