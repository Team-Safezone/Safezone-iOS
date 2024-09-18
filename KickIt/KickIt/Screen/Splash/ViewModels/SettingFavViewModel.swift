//
//  SettingFanViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import Combine
import Foundation

class SettingFavViewModel: ObservableObject {
    @Published var selectedTeams: [Int] = []
    @Published var teams: [SoccerTeam] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTeams()
    }
    
    /// 선호팀 3팀
    func selectTeam(_ teamIndex: Int) {
        if let index = selectedTeams.firstIndex(of: teamIndex) {
            selectedTeams.remove(at: index)
        } else if selectedTeams.count < 3 {
            selectedTeams.append(teamIndex)
        }
    }
    
    /// 선호 팀 설정 API
    func setFavoriteTeams(completion: @escaping () -> Void) {
        let selectedTeamNames = selectedTeams.map { teams[$0].teamName }
        UserAPI.shared.setFavoriteTeams(teams: selectedTeamNames)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("Favorite teams set successfully")
                    completion()
                case .failure(let error):
                    print("Failed to set favorite teams: \(error)")
                }
            } receiveValue: { _ in
                // 성공 처리
                completion()
            }
            .store(in: &cancellables)
    }

    /// 프리미어리그 팀 get API
    private func fetchTeams() {
        UserAPI.shared.getTeams()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch teams: \(error)")
                }
            } receiveValue: { [weak self] teams in
                self?.teams = teams
            }
            .store(in: &cancellables)
    }
    
    // 축구 팀 더미 데이터
//    var teams: [SoccerTeam] = [
//        SoccerTeam(
//            ranking: 0,
//            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg",
//            teamName: "리버풀"),
//        SoccerTeam(
//            ranking: 1,
//            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
//            teamName: "토트넘"),
//        SoccerTeam(
//            ranking: 2,
//            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
//            teamName: "맨시티"),
//        SoccerTeam(
//            ranking: 3,
//            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
//            teamName: "아스널"),
//        SoccerTeam(
//            ranking: 4,
//            teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg",
//            teamName: "애스턴 빌라"),
//    ]
}
