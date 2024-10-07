//
//  PredictionButtonViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/6/24.
//

import Foundation
import Combine

/// 경기 정보 화면의 경기 예측 버튼 클릭 뷰모델
final class PredictionButtonViewModel: ObservableObject {
    /// 우승팀 예측 정보
    @Published var matchPrediction: PredictionMatchInfo
    
    /// 선발라인업 예측 정보
    @Published var lineupPrediction: PredictionLineupInfo
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.matchPrediction = PredictionMatchInfo(homePercentage: 0, isParticipated: false)
        self.lineupPrediction = PredictionLineupInfo(isParticipated: false)
    }
    
    /// 경기 예측 버튼 클릭 조회
    func getPredictionButtonClick(request: PredictionButtonRequest) {
        MatchCalendarAPI.shared.getPredictoinButtonClick(request: request)
            .map { dto in
                let matchPredictions = self.matchPredictionToEntity(dto.matchPredictions)
                let lineupPredictions = self.lineupPredictionToEntity(dto.lineupPredictions)
                
                return (matchPredictions, lineupPredictions)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (matchPredictions, lineupPredictions) in
                self?.matchPrediction = matchPredictions
                self?.lineupPrediction = lineupPredictions
            })
            .store(in: &cancellables)
    }
    
    /// 경기 결과 예측 DTO -> Entity
    private func matchPredictionToEntity(_ dto: ButtonMatchPredictionResponse) -> PredictionMatchInfo {
        return PredictionMatchInfo(
            homePercentage: dto.homePercentage,
            isParticipated: dto.isParticipated,
            participant: dto.participant,
            isPredictionSuccessful: dto.isPredictionSuccessful
        )
    }
    
    /// 선발라인업 예측 DTO -> Entity
    private func lineupPredictionToEntity(_ dto: ButtonLineupPredictionResponse) -> PredictionLineupInfo {
        return PredictionLineupInfo(
            homePercentage: dto.homePercentage,
            awayPercentage: dto.awayPercentage,
            homeFormation: dto.homeFormation,
            awayFormation: dto.awayFormation,
            isParticipated: dto.isParticipated,
            participant: dto.participant,
            isPredictionSuccessful: dto.isPredictionSuccessful
        )
    }
    
    /// 팀 정보에 따른 포메이션 정보 반환
    func formationInfo(for isHomeTeam: Bool) -> (String, Int) {
        let formationIndex = isHomeTeam ? lineupPrediction.homeFormation : lineupPrediction.awayFormation
        
        // 포메이션 정보 반환
        var formation: String = ""
        switch formationIndex {
        case 0: formation = "4-3-3"
        case 1: formation = "4-2-3-1"
        case 2: formation = "4-4-2"
        case 3: formation = "3-4-3"
        case 4: formation = "4-5-1"
        case 5: formation = "3-5-2"
        default: formation = "-"
        }
        
        // 퍼센트 반환
        let percentage = isHomeTeam ? lineupPrediction.homePercentage ?? 0: lineupPrediction.awayPercentage ?? 0
        
        return (formation, percentage)
    }
}
