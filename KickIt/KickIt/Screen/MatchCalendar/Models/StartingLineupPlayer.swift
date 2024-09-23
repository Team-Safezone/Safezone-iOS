//
//  StartingLineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

/// [Entity] 선발라인업 화면에서 사용되는 선수 정보
struct StartingLineupPlayer {
    var playerImgURL: String // 선수 이미지 URL
    var playerName: String // 선수 이름
    var backNum: Int // 선수 등번호
    var playerPosition: Int // 선수 포지션
}

/// 토트넘 선수 리스트 더미 데이터
var dummyStartingLineupPlayer: [StartingLineupPlayer] = [
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p85971.png", playerName: "손흥민", backNum: 7, playerPosition: 4),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p242898.png", playerName: "존슨", backNum: 22, playerPosition: 4),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p227127.png", playerName: "비수마", backNum: 8, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p172780.png", playerName: "매디슨", backNum: 10, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p547701.png", playerName: "그레이", backNum: 14, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p570526.png", playerName: "베리발", backNum: 15, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p445044.png", playerName: "쿨루셰프스키", backNum: 21, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p482442.png", playerName: "사르", backNum: 29, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p202993.png", playerName: "벤탄쿠르", backNum: 30, playerPosition: 3),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p115556.png", playerName: "데이비스", backNum: 33, playerPosition: 2),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p491279.png", playerName: "판 더 펜", backNum: 37, playerPosition: 2),
    StartingLineupPlayer(playerImgURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p184254.png", playerName: "비카리오", backNum: 1, playerPosition: 1)
]
