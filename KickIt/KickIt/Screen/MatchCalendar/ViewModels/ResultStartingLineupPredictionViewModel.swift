//
//  ResultStartingLineupPredictionViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/12/24.
//

import Foundation
import Combine

/// 선발라인업 예측 결과 조회 뷰모델
final class ResultStartingLineupPredictionViewModel: ObservableObject {
    /// 필수 데이터 모델
    private var prediction: PredictionQuestionModel
    
    /// API 로딩 여부
    @Published var isLoading: Bool = false
    
    /// 예측에 참여한 사용자
    @Published var participant: Int = 0
    
    /// 홈팀 포메이션
    @Published var homeFormation: String?
    
    /// 원정팀 포메이션
    @Published var awayFormation: String?
    
    /// 홈팀 선발라인업
    @Published var homeLineups: StartingLineupModel?
    
    /// 원정팀 선발라인업
    @Published var awayLineups: StartingLineupModel?
    
    /// 사용자가 예측한 홈팀 포메이션
    @Published var userHomeFormation: Int?
    
    /// 사용자가 예측한 홈팀 선발라인업
    @Published var userHomePrediction: UserStartingLineupPrediction?
    
    /// 사용자가 예측한 원정팀 포메이션
    @Published var userAwayFormation: Int?
    
    /// 사용자가 예측한 원정팀 선발라인업
    @Published var userAwayPrediction: UserStartingLineupPrediction?
    
    /// 평균 예측 홈팀 포메이션
    @Published var avgHomeFormation: Int?
    
    /// 평균 예측 홈팀 선발라인업
    @Published var avgHomePrediction: UserStartingLineupPrediction?
    
    /// 평균 예측 원정팀 포메이션
    @Published var avgAwayFormation: Int?
    
    /// 평균 예측 원정팀 선발라인업
    @Published var avgAwayPrediction: UserStartingLineupPrediction?
    
    /// 사용자의 예측 성공 여부[홈팀, 원정팀]
    @Published var userPrediction: [Bool]?
    
    /// 평균 예측 성공 여부[홈팀, 원정팀]
    @Published var avgPrediction: [Bool]?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(prediction: PredictionQuestionModel) {
        self.prediction = prediction
        // 선발라인업 예측 결과 조회 API 호출
        getResultStartingLineupPrediction(query: MatchIdRequest(matchId: prediction.matchId))
    }
    
    /// 선발라인업 예측 결과 조회 API
    func getResultStartingLineupPrediction(query: MatchIdRequest) {
        isLoading = true // API 요청 시작
        StartingLineupPredictionAPI.shared.getResultStartingLineupPrediction(request: query)
            .map { dto in
                let participant = dto.participant
                let homeFormation = dto.homeFormation
                let awayFormation = dto.awayFormation
                let homeLineups = self.lineupToEntity(dto.homeLineups)
                let awayLineups = self.lineupToEntity(dto.awayLineups)
                let userHomeFormation = dto.userHomeFormation ?? nil
                let userHomePrediction = dto.userHomePrediction != nil ? self.predictionToEntity(dto.userHomePrediction) : nil
                let userAwayFormation = dto.userAwayFormation ?? nil
                let userAwayPrediction = dto.userAwayPrediction != nil ? self.predictionToEntity(dto.userAwayPrediction) : nil
                let avgHomeFormation = dto.avgHomeFormation ?? nil
                let avgHomePrediction = dto.avgHomePrediction != nil ? self.predictionToEntity(dto.avgHomePrediction) : nil
                let avgAwayFormation = dto.avgAwayFormation ?? nil
                let avgAwayPrediction = dto.avgAwayPrediction != nil ? self.predictionToEntity(dto.avgAwayPrediction) : nil
                let userPrediction = dto.userPrediction
                let avgPrediction = dto.avgPrediction
                
                return (participant, homeFormation, awayFormation, homeLineups, awayLineups, userHomeFormation, userHomePrediction, userAwayFormation, userAwayPrediction, avgHomeFormation, avgHomePrediction, avgAwayFormation, avgAwayPrediction, userPrediction, avgPrediction)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                self.isLoading = false // 로딩 완료
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] (participant, homeFormation, awayFormation, homeLineups, awayLineups, userHomeFormation, userHomePrediction, userAwayFormation, userAwayPrediction, avgHomeFormation, avgHomePrediction, avgAwayFormation, avgAwayPrediction, userPrediction, avgPrediction) in
                self?.participant = participant
                self?.homeFormation = homeFormation
                self?.awayFormation = awayFormation
                self?.homeLineups = homeLineups
                self?.awayLineups = awayLineups
                self?.userHomeFormation = userHomeFormation
                self?.userHomePrediction = userHomePrediction
                self?.userAwayFormation = userAwayFormation
                self?.userAwayPrediction = userAwayPrediction
                self?.avgHomeFormation = avgHomeFormation
                self?.avgHomePrediction = avgHomePrediction
                self?.avgAwayFormation = avgAwayFormation
                self?.avgAwayPrediction = avgAwayPrediction
                self?.userPrediction = userPrediction
                self?.avgPrediction = avgPrediction
            })
            .store(in: &cancellables)
    }
    
    private func lineupToEntity(_ dto: TeamStartingLineupResponse2?) -> StartingLineupModel {
        let goalkeeper = dto?.goalkeeper?.compactMap { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let defenders = dto?.defenders?.compactMap { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let midfielders = dto?.midfielders?.compactMap { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let midfielders2 = dto?.secondMidFielders?.compactMap { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let strikers = dto?.strikers?.compactMap { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        
        return StartingLineupModel(
            goalkeeper: goalkeeper,
            defenders: defenders,
            midfielders: midfielders,
            midfielders2: midfielders2,
            strikers: strikers
        )
    }
    
    /// 사용자 예측&평균 예측 선발라인업 선수 리스트를 변환하는 함수(DTO -> Entity)
    private func predictionToEntity(_ dto: StartingLineupPredictionCommonResultResponse?) -> UserStartingLineupPrediction {
        return UserStartingLineupPrediction(
            formation: -1,
            goalkeeper: SoccerPlayer(
                playerImgURL: dto?.goalkeeper?.playerImgURL ?? "",
                playerName: dto?.goalkeeper?.playerName ?? "",
                backNum: dto?.goalkeeper?.playerNum ?? 0
            ),
            defenders: dto?.defenders!.compactMap { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            } ?? [],
            midfielders: dto?.midfielders!.compactMap { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            } ?? [],
            strikers: dto?.strikers!.compactMap { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            } ?? []
        )
    }
}
