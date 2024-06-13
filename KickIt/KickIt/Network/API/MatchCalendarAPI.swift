//
//  MatchCalendarAPI.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Alamofire
import Combine
import Foundation

/// 경기 캘린더 화면에서 사용하는 API
class MatchCalendarAPI: BaseAPI {
    static let shared = MatchCalendarAPI()
    
    private override init() { 
        super.init()
    }
    
    /// 한달 경기 일정 조회 API
    func getYearMonthSoccerMatches(yearMonth: String, teamName: String?) -> AnyPublisher<[SoccerMatchDate], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            AlamoFireManager.request(MatchCalendarService.getYearMonthSoccerMatches(yearMonth: yearMonth, teamName: teamName)).responseData { response in
                switch response.result {
                // 응답 받기 성공
                case .success(let data):
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    let result = self.judgeStatus(by: statusCode, data, [SoccerMatchMonthResponseModel].self)
                    switch result {
                    // 성공
                    case .success(let matchDatesDTO):
                        // 서버에서 전달받은 데이터를 앱 내부에서 사용하는 데이터 타입으로 변환
                        let matchDates = matchDatesDTO.map { dto in
                            SoccerMatchDate(matchDate: stringToDate2(date: dto.matchDate))
                        }
                        promise(.success(matchDates))
                    // 실패
                    // 요청 에러
                    case .requestErr(let errorMessage):
                        promise(.failure(NetworkError.requestError(errorMessage)))
                    // 경로 에러
                    case .pathErr:
                        promise(.failure(NetworkError.pathError))
                    // 서버 내부 에러
                    case .serverErr:
                        promise(.failure(NetworkError.serverError))
                    // 네트워크 에러
                    case .networkFail:
                        promise(.failure(NetworkError.networkFail))
                    }
                // 응답 받기 실패
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 하루 경기 일정 조회 API
    func getDaySoccerMatches(date: String, teamName: String?) -> AnyPublisher<[SoccerMatch], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            AlamoFireManager.request(MatchCalendarService.getDaySoccerMatches(date: date, teamName: teamName)).responseData { response in
                switch response.result {
                // 성공
                case .success(let data):
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    let result = self.judgeStatus(by: statusCode, data, [SoccerMatchResponseModel].self)
                    switch result {
                    // 응답 받기 성공
                    case .success(let matchDTO):
                        // 서버에서 전달받은 데이터를 앱 내부에서 사용하는 데이터 타입으로 변환
                        let matches = matchDTO.map { dto in
                            SoccerMatch(
                                id: dto.id,
                                // 2024-05-16
                                soccerSeason: dto.soccerSeason,
                                matchDate: stringToDate(date: dto.matchDate),
                                matchTime: stringToTime(time: dto.matchTime),
                                stadium: dto.stadium,
                                matchRound: dto.matchRound,
                                homeTeam: SoccerTeam(
                                    id: 0,
                                    teamEmblemURL: "엠블럼",
                                    teamName: dto.homeTeamName
                                ),
                                awayTeam: SoccerTeam(
                                    id: 0,
                                    teamEmblemURL: "엠블럼",
                                    teamName: dto.awayTeamName
                                ),
                                matchCode: dto.matchCode,
                                homeTeamScore: dto.homeTeamScore,
                                awayTeamScore: dto.awayTeamScore
                            )
                        }
                        promise(.success(matches))
                    // 요청 에러
                    case .requestErr(let errorMessage):
                        promise(.failure(NetworkError.requestError(errorMessage)))
                    // 경로 에러
                    case .pathErr:
                        promise(.failure(NetworkError.pathError))
                    // 서버 내부 에러
                    case .serverErr:
                        promise(.failure(NetworkError.serverError))
                    // 네트워크 에러
                    case .networkFail:
                        promise(.failure(NetworkError.networkFail))
                    }
                // 응답 받기 실패
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
