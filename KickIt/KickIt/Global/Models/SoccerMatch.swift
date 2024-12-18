//
//  SoccerMatch.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import Foundation

/// [Entity] 축구 경기 모델
struct SoccerMatch: Identifiable, Hashable {
    let id: Int64 // 고유 id
    let matchDate: Date // 축구 경기 날짜
    let matchTime: Date // 축구 경기 시간
    let stadium: String // 축구 경기 장소
    let matchRound: Int // 라운드
    let homeTeam: SoccerTeam // 홈 팀
    let awayTeam: SoccerTeam // 원정 팀
    var matchCode: Int // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
    var homeTeamScore: Int? // 홈 팀 스코어
    var awayTeamScore: Int? // 원정 팀 스코어
}

/// 축구 경기 리스트 더미 데이터
let dummySoccerMatches: [SoccerMatch] = [
    SoccerMatch(
        id: 53,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 21))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 19, minute: 20))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F43_300300.png", teamName: "풀럼"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", teamName: "맨시티"),
        matchCode: 1,
        homeTeamScore: 1,
        awayTeamScore: 0
    ),
    
    SoccerMatch(
        id: 1,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 7))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 3, minute: 20))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F3_300300.png", teamName: "울버햄튼"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F7_300300.png", teamName: "팰리스"),
        matchCode: 0
    ),

    SoccerMatch(
        id: 2,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 15))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 1, minute: 00))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F48_300300.png", teamName: "에버턴"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F42_300300.png", teamName: "아스널"),
        matchCode: 3
    ),
    
    /// 예정 경기
    SoccerMatch(
        id: 3,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 22))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 1, minute: 30))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F42_300300.png", teamName: "아스널"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F44_300300.png", teamName: "리버풀"),
        matchCode: 0
    ),
    SoccerMatch(
        id: 4,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 24))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 12, minute: 30))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", teamName: "맨시티"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png", teamName: "토트넘"),
        matchCode: 0
    ),
    SoccerMatch(
        id: 5,
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 28))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F43_300300.png", teamName: "풀럼"),
        awayTeam: SoccerTeam(ranking: 0, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F7_300300.png", teamName: "팰리스"),
        matchCode: 0
    )
    
]
