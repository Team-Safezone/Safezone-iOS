//
//  WinningTeamPredictionViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation
import Combine

/// 우승팀 예측 화면 뷰 모델
final class WinningTeamPredictionViewModel: ObservableObject {
    /// 홈팀의 예상 골 개수
    @Published var homeTeamGoal: Int = 0
    
    /// 원정팀의 예상 골 개수
    @Published var awayTeamGoal: Int = 0
    
    /// 등급
    @Published var grade: Int = 0
    
    /// 포인트
    @Published var point: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 각 팀의 예상 골 개수 업데이트
    func updateGoal(for goal: inout Int, isAdd: Bool) {
        if isAdd {
            goal += 1
        }
        else {
            goal -= 1
        }
    }

    /// 홈팀 골 추가
    func addHomeTeamGoal() {
        updateGoal(for: &homeTeamGoal, isAdd: true)
    }

    /// 원정팀 골 추가
    func addAwayTeamGoal() {
        updateGoal(for: &awayTeamGoal, isAdd: true)
    }

    /// 홈팀 골 삭제
    func minusHomeTeamGoal() {
        updateGoal(for: &homeTeamGoal, isAdd: false)
    }

    /// 원정팀 골 삭제
    func minusAwayTeamGoal() {
        updateGoal(for: &awayTeamGoal, isAdd: false)
    }
    
    /// 우승팀 예측 API
    func postWinningTeamPrediction(query: MatchIdRequest, request: WinningTeamPredictionRequest) {
        WinningTeamPredictionAPI.shared.postWinningTeamPrediction(query: query, request: request)
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
                self?.grade = dto.grade
                self?.point = dto.point
            })
            .store(in: &cancellables)
    }
}
