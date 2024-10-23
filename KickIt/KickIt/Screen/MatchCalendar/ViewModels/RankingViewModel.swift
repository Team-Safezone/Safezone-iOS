//
//  RankingViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation
import Combine

/// 랭킹 뷰모델
final class RankingViewModel: ObservableObject {
    /// 랭킹 리스트
    @Published var rankings: [RankingModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getRanking()
        rankings = dummyRankings // FIXME: API연동시 더미데이터 삭제
    }
    
    /// 랭킹 조회
    private func getRanking() {
        MatchCalendarAPI.shared.getRanking()
            .map { dto in
                let tempRankings = dto.map { data in
                    RankingModel(
                        team: SoccerTeam(ranking: data.ranking, teamEmblemURL: data.teamUrl, teamName: data.teamName),
                        totalMatches: data.totalMatches,
                        wins: data.wins,
                        draws: data.draws,
                        losses: data.losses,
                        points: data.points,
                        leagueCategory: data.leagueCategory
                    )
                }
                return tempRankings
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] rankings in
                self?.rankings = rankings
            })
            .store(in: &cancellables)
    }
    
    /// 랭킹 더미데이터
    let dummyRankings: [RankingModel] = [
        RankingModel(team: SoccerTeam(ranking: 1, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", teamName: "맨시티"), totalMatches: 6, wins: 4, draws: 2, losses: 0, points: 14, leagueCategory: 0),
        RankingModel(team: SoccerTeam(ranking: 2, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F44_300300.png", teamName: "리버풀"), totalMatches: 5, wins: 4, draws: 0, losses: 1, points: 12, leagueCategory: 0),
        RankingModel(team: SoccerTeam(ranking: 3, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F40_300300.png", teamName: "애스턴 빌라"), totalMatches: 5, wins: 3, draws: 1, losses: 1, points: 12, leagueCategory: 0),
        RankingModel(team: SoccerTeam(ranking: 4, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F42_300300.png", teamName: "아스날"), totalMatches: 5, wins: 3, draws: 2, losses: 0, points: 11, leagueCategory: 0),
        RankingModel(team: SoccerTeam(ranking: 5, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F39_300300.png", teamName: "뉴캐슬"), totalMatches: 5, wins: 3, draws: 2, losses: 0, points: 11, leagueCategory: 1),
        RankingModel(team: SoccerTeam(ranking: 6, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F38_300300.png", teamName: "첼시"), totalMatches: 5, wins: 3, draws: 1, losses: 1, points: 10),
        RankingModel(team: SoccerTeam(ranking: 7, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F30_300300.png", teamName: "브라이튼"), totalMatches: 5, wins: 2, draws: 3, losses: 0, points: 9),
        RankingModel(team: SoccerTeam(ranking: 8, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F14_300300.png", teamName: "노팅엄"), totalMatches: 5, wins: 2, draws: 3, losses: 0, points: 9),
        RankingModel(team: SoccerTeam(ranking: 9, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F43_300300.png", teamName: "풀럼"), totalMatches: 5, wins: 2, draws: 1, losses: 2, points: 7),
        RankingModel(team: SoccerTeam(ranking: 10, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png", teamName: "토트넘"), totalMatches: 5, wins: 2, draws: 1, losses: 2, points: 7),
        RankingModel(team: SoccerTeam(ranking: 11, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F35_300300.png", teamName: "맨유"), totalMatches: 5, wins: 2, draws: 1, losses: 2, points: 7),
        RankingModel(team: SoccerTeam(ranking: 12, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F50_300300.png", teamName: "브렌트퍼드"), totalMatches: 5, wins: 2, draws: 0, losses: 3, points: 6),
        RankingModel(team: SoccerTeam(ranking: 13, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F60_300300.png", teamName: "본머스"), totalMatches: 5, wins: 1, draws: 2, losses: 2, points: 5),
        RankingModel(team: SoccerTeam(ranking: 14, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F37_300300.png", teamName: "웨스트햄"), totalMatches: 5, wins: 1, draws: 1, losses: 3, points: 4),
        RankingModel(team: SoccerTeam(ranking: 15, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F31_300300.png", teamName: "레스터시티"), totalMatches: 5, wins: 0, draws: 3, losses: 2, points: 3),
        RankingModel(team: SoccerTeam(ranking: 16, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F7_300300.png", teamName: "크리스탈 팰리스"), totalMatches: 5, wins: 0, draws: 3, losses: 2, points: 3),
        RankingModel(team: SoccerTeam(ranking: 17, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F32_300300.png", teamName: "입스위치"), totalMatches: 5, wins: 0, draws: 3, losses: 2, points: 3),
        RankingModel(team: SoccerTeam(ranking: 18, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F45_300300.png", teamName: "사우샘프턴"), totalMatches: 5, wins: 0, draws: 1, losses: 4, points: 1, leagueCategory: 2),
        RankingModel(team: SoccerTeam(ranking: 19, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F48_300300.png", teamName: "에버턴"), totalMatches: 5, wins: 0, draws: 1, losses: 4, points: 1, leagueCategory: 2),
        RankingModel(team: SoccerTeam(ranking: 20, teamEmblemURL: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F3_300300.png", teamName: "울브스"), totalMatches: 5, wins: 0, draws: 1, losses: 4, points: 1, leagueCategory: 2)
    ]
}
