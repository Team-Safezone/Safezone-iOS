//
//  StartingLineupModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation

/// [Entity] 각팀 선발라인업 리스트 모델
struct StartingLineupModel {
    var goalkeeper: [SoccerPlayer] // 골기퍼
    var defenders: [SoccerPlayer] // 수비수
    var midfielders: [SoccerPlayer] // 미드필더
    var midfielders2: [SoccerPlayer]? // 미드필더2
    var strikers: [SoccerPlayer] // 공격수
}

/// 4-2-3-1 포메이션 더미 데이터
var dummyGoalkeeper = [SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p184254.png", playerName: "비카리오", backNum: 1)]

var dummyDF1: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p487053.png", playerName: "우도기", backNum: 13),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p221632.png", playerName: "로메로", backNum: 17),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p115556.png", playerName: "데이비스", backNum: 33),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p491279.png", playerName: "판 더 펜", backNum: 37),
]

var dummyMF1: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p227127.png", playerName: "비수마", backNum: 8),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p172780.png", playerName: "매디슨", backNum: 10)
]

var dummyMF2: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p547701.png", playerName: "그레이", backNum: 14),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p570526.png", playerName: "베리발", backNum: 15),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p445044.png", playerName: "쿨루셰프스키", backNum: 21)
]

var dummyST1: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p85971.png", playerName: "손흥민", backNum: 7)
]

/// 5-3-2 포메이션 더미 데이터
var dummyDF2: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p487053.png", playerName: "우도기", backNum: 13),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p221632.png", playerName: "로메로", backNum: 17),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p441164.png", playerName: "포로", backNum: 23),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p115556.png", playerName: "데이비스", backNum: 33),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p491279.png", playerName: "판 더 펜", backNum: 37),
]

var dummyMF3: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p570526.png", playerName: "베리발", backNum: 15),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p445044.png", playerName: "쿨루셰프스키", backNum: 21),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p482442.png", playerName: "사르", backNum: 29)
]

var dummyST2: [SoccerPlayer] = [
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p85971.png", playerName: "손흥민", backNum: 7),
    SoccerPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p242898.png", playerName: "존슨", backNum: 22)
]

