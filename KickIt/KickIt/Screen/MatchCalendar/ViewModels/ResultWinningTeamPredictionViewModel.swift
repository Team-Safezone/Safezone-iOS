//
//  ResultWinningTeamPredictionViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation
import SwiftUI
import Combine

/// 우승팀 예측 결과 화면 뷰모델
final class ResultWinningTeamPredictionViewModel: ObservableObject {
    /// 필수 데이터 모델
    private var prediction: PredictionQuestionModel
    
    /// 우승팀 예측 결과
    @Published var result: WinningTeamPredictionResultResponse
    
    private var cancellables = Set<AnyCancellable>()
    
    init(prediction: PredictionQuestionModel) {
        self.prediction = prediction
        result = WinningTeamPredictionResultResponse(participant: 0)
        getResultWinningTeamPrediction(query: MatchIdRequest(matchId: prediction.matchId))
    }
    
    /// 우승팀 예측 결과 조회 API
    func getResultWinningTeamPrediction(query: MatchIdRequest) {
        WinningTeamPredictionAPI.shared.getWinningTeamPredictionResult(request: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] dto in
                self?.result = dto
            })
            .store(in: &cancellables)
    }
    
    /// 승패 여부 반환 함수
    func whoIsWinner(_ team1: Int?, _ team2: Int?) -> (String, String, Color, Color) {
        guard let team1 = team1, let team2 = team2 else {
            return ("", "", Color.white0, Color.white0)
        }
        
        if team1 > team2 {
            return ("승리", "패배", Color.blue0, Color.red0)
        }
        else if team1 < team2 {
            return ("패배", "승리", Color.red0, Color.blue0)
        }
        else {
            return ("무승부", "무승부", Color.violet, Color.violet)
        }
    }
    
    /// 사용자가 우승팀을 예측했는지에 대한 여부
    func isParticipated(_ team: Int?) -> (String) {
        guard let team = team else {
            return ("-")
        }
        return "\(team) 골"
    }
}
