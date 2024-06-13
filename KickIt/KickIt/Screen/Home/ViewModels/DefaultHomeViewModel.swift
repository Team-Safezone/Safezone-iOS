//
//  DefaultHomeViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/14/24.
//

import Combine
import Foundation

/// 홈 화면의 뷰 모델
final class DefaultHomeViewModel: HomeViewModel {
    @Published var soccerTeams: [SoccerTeam] = [] // 프리미어리그 팀 리스트
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    /// 프리미어리그 팀 리스트 조회
    func requestSoccerTeams(soccerSeason: String) {
        HomeAPI.shared.getSoccerTeams(soccerSeason: soccerSeason)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] teams in
                self?.soccerTeams = teams
            })
            .store(in: &cancellables)
    }
}
