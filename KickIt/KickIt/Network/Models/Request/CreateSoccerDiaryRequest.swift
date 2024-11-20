//
//  CreateSoccerDiaryRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation

/// 축구 일기 작성 Request 모델
struct CreateSoccerDiaryRequest: Encodable {
    var matchId: Int64
    var teamName: String
    var emotion: Int
    var diaryContent: String
    var mom: String?
    var isPublic: Bool
}
