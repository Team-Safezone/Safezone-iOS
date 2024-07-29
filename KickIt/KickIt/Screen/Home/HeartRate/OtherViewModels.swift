//
//  OtherViewModels.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation
import SwiftUI
import Combine


class FanListViewModel: ObservableObject {
    @Published var homeTeamName: String
    @Published var awayTeamName: String
    
    init(homeTeam: SoccerTeam, awayTeam: SoccerTeam) {
        self.homeTeamName = homeTeam.teamName
        self.awayTeamName = awayTeam.teamName
    }
    
    func updateTeams(homeTeam: SoccerTeam, awayTeam: SoccerTeam) {
        self.homeTeamName = homeTeam.teamName
        self.awayTeamName = awayTeam.teamName
    }
}

class BoxEventViewModel: ObservableObject {
    @Published var dataPoint: CGFloat
    @Published var time: Int
    @Published var event: MatchEvent?
    @Published var homeTeamEmblemURL: String?
    
    init(dataPoint: CGFloat, time: Int, event: MatchEvent? = nil, homeTeamEmblemURL: String? = nil) {
        self.dataPoint = dataPoint
        self.time = time
        self.event = event
        self.homeTeamEmblemURL = homeTeamEmblemURL
    }
}



class ViewerStatsViewModel: ObservableObject {
    @Published var homeTeam: SoccerTeam
    @Published var awayTeam: SoccerTeam
    @Published var homeTeamPercentage: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(homeTeam: SoccerTeam, awayTeam: SoccerTeam, homeTeamPercentage: Int) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeTeamPercentage = homeTeamPercentage
    }
    
    func updateMatch(homeTeam: SoccerTeam, awayTeam: SoccerTeam, homeTeamPercentage: Int) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeTeamPercentage = homeTeamPercentage
    }
    
    /// 홈 팀 시청자 비율 조회
    func fetchViewerPercentage(matchID: Int) {
        HeartRateAPI.shared.getViewerPercentage(matchID: matchID)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching viewer percentage: \(error)")
                }
            }, receiveValue: { [weak self] percentage in
                self?.homeTeamPercentage = percentage
            })
            .store(in: &cancellables)
    }
}

class ViewerHRStatsViewModel: ObservableObject {
    @Published var homeTeamName: String
    @Published var awayTeamName: String
    @Published var homeTeamStats: [String]
    @Published var awayTeamStats: [String]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(homeTeam: SoccerTeam, awayTeam: SoccerTeam) {
        self.homeTeamName = homeTeam.teamName
        self.awayTeamName = awayTeam.teamName
        self.homeTeamStats = ["75", "98", "110"]
        self.awayTeamStats = ["76", "89", "120"]
    }
    
    /// 경기 변경 시 팀 변경 함수
    func updateTeams(homeTeam: SoccerTeam, awayTeam: SoccerTeam) {
        self.homeTeamName = homeTeam.teamName
        self.awayTeamName = awayTeam.teamName
        fetchTeamHeartRate(teamName: homeTeam.teamName, isHomeTeam: true)
        fetchTeamHeartRate(teamName: awayTeam.teamName, isHomeTeam: false)
    }
    
    /// 팀 별 심박수 데이터 조회
    func fetchTeamHeartRate(teamName: String, isHomeTeam: Bool) {
        HeartRateAPI.shared.getTeamHeartRate(teamName: teamName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching team heart rate: \(error)")
                }
            }, receiveValue: { [weak self] heartRateData in
                let stats = [String(heartRateData.min), String(heartRateData.avg), String(heartRateData.max)]
                if isHomeTeam {
                    self?.homeTeamStats = stats
                } else {
                    self?.awayTeamStats = stats
                }
            })
            .store(in: &cancellables)
    }
}
