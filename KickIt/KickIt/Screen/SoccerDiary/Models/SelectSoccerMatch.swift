//
//  SelectSoccerMatch.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import Foundation

/// [Entity] 축구 일기 - 완료된 경기 리스트
struct SelectSoccerMatch: Identifiable, Hashable {
    var id: Int64
    var matchDate: Date
    var matchTime: String
    var homeTeamEmblemURL: String
    var awayTeamEmblemURL: String
    var homeTeamName: String
    var awayTeamName: String
    var homeTeamScore: Int?
    var awayTeamScore: Int?
}

let dummySelectSoccerMatch = SelectSoccerMatch(id: 0, matchDate: Date(), matchTime: "01:30", homeTeamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png", awayTeamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", homeTeamName: "토트넘", awayTeamName: "맨시티", homeTeamScore: 1, awayTeamScore: 2)
