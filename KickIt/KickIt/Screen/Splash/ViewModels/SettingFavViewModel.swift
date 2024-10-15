//
//  SettingFanViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import Combine
import Foundation

// 팀 고르기 뷰모델
class SettingFavViewModel: ObservableObject {
    @Published var selectedTeams: [String] = []
    @Published var teams: [SoccerTeam] = dummyscteams //[]
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTeams()
    }
    
    /// 팀 선택 함수
    func selectTeam(_ team: SoccerTeam) {
        if let index = selectedTeams.firstIndex(of: team.teamName) {
            selectedTeams.remove(at: index)
        } else if selectedTeams.count < 3 {
            selectedTeams.append(team.teamName)
        }
    }
    
    /// 선호 팀 설정
    func setFavoriteTeams(to mainViewModel: MainViewModel, completion: @escaping () -> Void) {
        mainViewModel.userSignUpInfo.favoriteTeams = selectedTeams
        completion()
    }
    
    /// 프리미어리그 팀 get API
    func fetchTeams() {
        UserAPI.shared.getTeams()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching soccerteams: \(error)")
                }
            } receiveValue: { [weak self] teams in
                self?.teams = teams
            }
            .store(in: &cancellables)
    }
}


// 축구 팀 더미 데이터
var dummyscteams: [SoccerTeam] = [
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
