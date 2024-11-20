//
//  HomeViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import Foundation
import Combine

/// 홈 화면의 뷰모델
final class HomeViewModel: ObservableObject {
    @Published var gradePoint: Int = 0 // 사용자가 획득한 골 개수
    @Published var matchPredictions: HomeMatch? // 경기 예측
    @Published var matchDiarys: HomeDiary? // 축구 일기 쓰기
    @Published var favoriteImagesURL: [String] = [] // 사용자의 관심있는 구단 이미지 URL 리스트
    @Published var matches: [SoccerMatch]? // 사용자에게 관심있을 경기 일정 리스트
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getHome()
    }
    
    /// 홈 조회
    func getHome() {
        HomeAPI.shared.getHome()
            .map { dto in
                let point = dto.gradePoint
                let predictions = dto.matchPredictions.map { match in
                    HomeMatch(
                        matchId: match.matchId,
                        matchDate: dateToDay(date: stringToDate(date: match.matchDate)),
                        matchTime: timeToString(time: stringToTime(time: match.matchTime)),
                        homeTeam: SoccerTeam(teamEmblemURL: match.homeTeamEmblemURL, teamName: match.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: match.awayTeamEmblemURL, teamName: match.awayTeamName)
                    )
                }
                let diarys = dto.matchDiarys.map { diary in
                    HomeDiary(
                        diaryId: diary.diaryId,
                        matchDate: dateToDay(date: stringToDate(date: diary.matchDate)),
                        matchTime: timeToString(time: stringToTime(time: diary.matchTime)),
                        homeTeam: SoccerTeam(teamEmblemURL: diary.homeTeamEmblemURL, teamName: diary.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: diary.awayTeamEmblemURL, teamName: diary.awayTeamName)
                    )
                }
                let favorites = dto.favoriteImagesURL
                let matches = dto.matches.map { tempMatches in
                    tempMatches.map { match in
                        SoccerMatch(
                            id: match.matchId,
                            matchDate: stringToDate(date: match.matchDate),
                            matchTime: stringToTime(time: match.matchTime),
                            stadium: match.stadium,
                            matchRound: match.matchRound,
                            homeTeam: SoccerTeam(teamEmblemURL: match.homeTeamEmblemURL, teamName: match.homeTeamName),
                            awayTeam: SoccerTeam(teamEmblemURL: match.awayTeamEmblemURL, teamName: match.awayTeamName),
                            matchCode: match.matchCode
                        )
                    }
                }
                
                return (point, predictions, diarys, favorites, matches)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (point, predictions, diarys, favorites, matches) in
                self?.gradePoint = point
                self?.matchPredictions = predictions
                self?.matchDiarys = diarys
                self?.favoriteImagesURL = favorites
                self?.matches = matches
            }
            .store(in: &cancellables)

    }
}
