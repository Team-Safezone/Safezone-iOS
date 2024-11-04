//
//  SoccerDiaryModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/20/24.
//

import Foundation
import SwiftUI

/// [Entity] 추천 축구 일기 모델
struct RecommendDiaryModel {
    let diaryId: Int64
    var grade: UIImage
    var teamUrl: String
    var teamName: String
    var nickname: String
    var diaryDate: String
    let matchDate: String
    let homeTeamName: String
    let homeTeamScore: Int
    let awayTeamName: String
    let awayTeamScore: Int
    var emotion: UIImage
    var highHeartRate: Int?
    var diaryContent: String
    var diaryPhotos: [String]?
    var mom: String?
    var isLiked: Bool
    var likes: Int
}
