//
//  SoccerTeam.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import Foundation

/// [Entity] 축구 팀 모델
struct SoccerTeam: Identifiable {
    var id: Int64 // 고유 id
    var teamEmblemURL: String // 팀 로고 이미지
    var teamName: String // 팀 이름
}

/// 축구 팀 더미 데이터
var dummySoccerTeams: [SoccerTeam] = [
    SoccerTeam(
        id: 0,
        teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg",
        teamName: "리버풀"),
    SoccerTeam(
        id: 1,
        teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
        teamName: "토트넘"),
    SoccerTeam(
        id: 2,
        teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
        teamName: "맨시티"),
    SoccerTeam(
        id: 3,
        teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
        teamName: "아스널"),
    SoccerTeam(
        id: 4,
        teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
        teamName: "애스턴 빌라"),
]
