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
    @Published var errorMessage: String?
    
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
    func setFavoriteTeams(to mainViewModel: MainViewModel, completion: @escaping () -> Void) {
        let selectedTeamNames = selectedTeams.map { teams[$0].teamName }
        mainViewModel.userSignUpInfo.favoriteTeams = selectedTeamNames
        completion()
    }
    
    /// 프리미어리그 팀 get API
    private func fetchTeams() {
        UserAPI.shared.getTeams()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] teams in
                self?.teams = teams
            }
            .store(in: &cancellables)
    }
    
    /// 에러 처리
    private func handleError(_ error: NetworkError) {
        switch error {
        case .requestErr(let message):
            errorMessage = "요청 오류: \(message)"
        case .pathErr:
            errorMessage = "경로 오류"
        case .serverErr(let message):
            errorMessage = "서버 오류: \(message)"
        case .networkFail(let message):
            errorMessage = "네트워크 오류: \(message)"
        case .authFailed:
            errorMessage = "인증 실패"
        case .unknown(let message):
            errorMessage = "알 수 없는 오류: \(message)"
        }
        print("Error occurred: \(errorMessage ?? "Unknown error")")
    }
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
