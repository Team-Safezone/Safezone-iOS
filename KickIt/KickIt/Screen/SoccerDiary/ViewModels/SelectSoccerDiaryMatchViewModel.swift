//
//  SelectSoccerDiaryMatchViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import Foundation
import Combine

/// 축구 일기를 작성할 경기를 선택할 수 있는 화면 뷰모델
final class SelectSoccerDiaryMatchViewModel: ObservableObject {
    /// 팀 이름 리스트
    @Published var soccerTeamNames: [String] = []
    
    /// 한달 경기 리스트
    @Published var matches: [SelectSoccerMatch] = []
    
    /// 이전 달 경기가 있는 지에 대한 여부
    @Published var isLeftExist: Bool = true
    
    /// 다음 달 경기가 있는 지에 대한 여부
    @Published var isRightExist: Bool = false
    
    /// 라디오그룹에서 선택한 팀 아이디
    @Published var selectedRadioBtnID: Int = 0
    
    /// 라디오그룹에서 선택한 팀 이름 정보
    @Published var selectedTeamName: String?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getSelectSoccerDiaryMatch(query: SoccerMatchMonthlyRequest(yearMonth: dateToString5(date: Date()), teamName: nil))
    }
    
    /// 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회
    func getSelectSoccerDiaryMatch(query: SoccerMatchMonthlyRequest) {
        SoccerDiaryAPI.shared.getSelectSoccerDiaryMatch(query: query)
            .map { dto in
                let teamNames: [String] = dto.soccerTeamNames ?? []
                let matches = dto.matches?.compactMap { data in
                    SelectSoccerMatch(
                        id: data.matchId,
                        matchDate: stringToDate(date: data.matchDate),
                        matchTime: data.matchTime,
                        homeTeamEmblemURL: data.homeTeamEmblemURL,
                        awayTeamEmblemURL: data.awayTeamEmblemURL,
                        homeTeamName: data.homeTeamName,
                        awayTeamName: data.awayTeamName,
                        homeTeamScore: data.homeTeamScore,
                        awayTeamScore: data.awayTeamScore
                    )
                } ?? []
                let isLeftExist = dto.isLeftExist
                let isRightExist = dto.isRightExist
                return (teamNames, matches, isLeftExist, isRightExist)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] (teamNames, matches, isLeftExist, isRightExist) in
                if !teamNames.isEmpty {
                    self?.soccerTeamNames = ["전체"] + teamNames
                }
                self?.matches = matches
                self?.isLeftExist = isLeftExist
                self?.isRightExist = isRightExist
            })
            .store(in: &cancellables)
    }
    
    /// 라디오 버튼 클릭 이벤트
    func selectedTeam(_ teamName: String, id: Int) {
        selectedRadioBtnID = id
        setSelectedTeamName(teamName: teamName)
    }
    
    /// 팀 이름 전환 함수
    func setSelectedTeamName(teamName: String?) {
        if (teamName == "전체") {
            selectedTeamName = nil
        }
        else {
            selectedTeamName = teamName
        }
    }
}
