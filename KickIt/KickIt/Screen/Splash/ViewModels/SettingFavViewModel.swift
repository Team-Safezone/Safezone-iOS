//
//  SettingFanViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import Foundation

class SettingFavViewModel: ObservableObject {
    @Published var selectedTeams: [Int] = []
    
    // 축구 팀 더미 데이터
    var teams: [SoccerTeam] = [
        SoccerTeam(
            ranking: 0,
            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg",
            teamName: "리버풀"),
        SoccerTeam(
            ranking: 1,
            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
            teamName: "토트넘"),
        SoccerTeam(
            ranking: 2,
            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
            teamName: "맨시티"),
        SoccerTeam(
            ranking: 3,
            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
            teamName: "아스널"),
        SoccerTeam(
            ranking: 4,
            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
            teamName: "애스턴 빌라"),
    ]
    
    func selectTeam(_ teamIndex: Int) {
        if let index = selectedTeams.firstIndex(of: teamIndex) {
            selectedTeams.remove(at: index)
        } else if selectedTeams.count < 3 {
            selectedTeams.append(teamIndex)
        }
    }
}
