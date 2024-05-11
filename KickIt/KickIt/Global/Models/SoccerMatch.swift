//
//  SoccerMatch.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import Foundation

/// 축구 팀 모델
struct SoccerTeam: Identifiable {
    var id = UUID().uuidString // 고유 id
    var teamImgURL: String // 팀 로고 이미지
    var teamName: String // 팀 이름
}

/// 축구 경기 모델
struct SoccerMatch: Identifiable {
    var id = UUID().uuidString // 고유 id
    var matchCode: Int // 경기 상태(0: 예정, 1: 진행 중, 2: 완료)
    var soccerSeason: String // 축구 경기 시즌
    var matchDate: Date // 축구 경기 날짜
    var matchTime: Date // 축구 경기 시간
    var matchRound: String // 라운드
    var homeTeam: SoccerTeam // 홈 팀
    var awayTeam: SoccerTeam // 원정 팀
    var homeTeamScore: Int? // 홈 팀 스코어
    var awayTeamScore: Int? // 원정 팀 스코어
}

/// 축구 경기 리스트 더미 데이터
var soccerMatches: [SoccerMatch] = [
    SoccerMatch(
        matchCode: 2,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-06"),
        matchTime: soccerMatchTime(time: "12:30"),
        matchRound: "36",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg", teamName: "리버풀 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg", teamName: "토트넘 홋스퍼 FC"),
        homeTeamScore: 4,
        awayTeamScore: 2),
    
    SoccerMatch(
        matchCode: 0,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-11"),
        matchTime: soccerMatchTime(time: "20:30"),
        matchRound: "37",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F33%2F80%2F97%2F146_100338097_team_image_url_1436772555621.jpg", teamName: "풀럼 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F06%2F146_2845906_team_image_url_1467618027703.jpg", teamName: "맨체스터 시티 FC")),
    
    SoccerMatch(
        matchCode: 0,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-11"),
        matchTime: soccerMatchTime(time: "23:00"),
        matchRound: "37",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F33%2F80%2F91%2F146_100338091_team_image_url_1436770583726.jpg", teamName: "울버햄튼 원더러스 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F13%2F146_100303313_team_image_url_1435211926961.png", teamName: "크리스탈 팰리스 FC")),
    
    SoccerMatch(
        matchCode: 0,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-11"),
        matchTime: soccerMatchTime(time: "23:00"),
        matchRound: "37",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg", teamName: "토트넘 홋스퍼 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F61%2F80%2F146_2846180_team_image_url_1687740624441.png", teamName: "번리 FC")),
    
    SoccerMatch(
        matchCode: 0,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-12"),
        matchTime: soccerMatchTime(time: "01:30"),
        matchRound: "37",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F62%2F94%2F146_2846294_team_image_url_1684745381013.png", teamName: "노팅엄 포레스트 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F32%2F93%2F146_100303293_team_image_url_1435195031845.jpg", teamName: "첼시 FC")),
    
    SoccerMatch(
        matchCode: 0,
        soccerSeason: "2023/24",
        matchDate: soccerMatchDate(date: "2024-05-13"),
        matchTime: soccerMatchTime(time: "12:30"),
        matchRound: "37",
        homeTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F04%2F146_100303304_team_image_url_1435202334744.jpg", teamName: "맨체스터 유나이티드 FC"),
        awayTeam: SoccerTeam(teamImgURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F02%2F146_100303302_team_image_url_1435201937372.jpg", teamName: "아스널 FC")),
]
