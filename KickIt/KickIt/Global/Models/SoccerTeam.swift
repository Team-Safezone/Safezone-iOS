//
//  SoccerTeam.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import Foundation

/// [Entity] 축구 팀 모델
struct SoccerTeam {
    var ranking: Int? // 랭킹
    var teamEmblemURL: String // 팀 로고 이미지
    var teamName: String // 팀 이름
}

/// 축구 팀 더미 데이터
var dummySoccerTeams: [SoccerTeam] = [
    SoccerTeam(
        ranking: 0,
        teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F44_300300.png",
        teamName: "리버풀"),
    SoccerTeam(
        ranking: 1,
        teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png",
        teamName: "토트넘"),
    SoccerTeam(
        ranking: 2,
        teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png",
        teamName: "맨시티"),
    SoccerTeam(
        ranking: 3,
        teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F42_300300.png",
        teamName: "아스널"),
    SoccerTeam(
        ranking: 4,
        teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F40_300300.png",
        teamName: "애스턴 빌라"),
]
