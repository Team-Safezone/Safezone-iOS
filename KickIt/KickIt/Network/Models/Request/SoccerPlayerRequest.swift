//
//  SoccerPlayerRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation

/// 선발라인업 예측 화면에서 사용되는 선수 정보 Request 모델
struct SoccerPlayerRequest: Encodable {
    var playerName: String // 선수 이름
    var playerNum: Int // 선수 등번호
}
