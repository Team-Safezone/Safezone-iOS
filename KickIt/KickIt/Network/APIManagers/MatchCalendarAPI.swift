//
//  MatchCalendarAPI.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Alamofire
import Combine

/// 경기 캘린더 화면에서 사용하는 API
class MatchCalendarAPI: BaseAPI {
    /// 경기 캘린더 전역 객체
    static let shared = MatchCalendarAPI()
    
    private override init() { 
        super.init()
    }
    
    /// 한달 경기 일정 조회 API
    func getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest) -> AnyPublisher<SoccerMatchMonthlyResponse, NetworkError> {
        return Future<SoccerMatchMonthlyResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MatchCalendarService.getYearMonthSoccerMatches(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<SoccerMatchMonthlyResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? SoccerMatchMonthlyResponse(soccerSeason: "", matchDates: [], soccerTeamNames: [])))
                        }
                        // 응답 실패
                        else {
                            switch result.status {
                            case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 하루 경기 일정 조회 API
    func getDailySoccerMatches(request: SoccerMatchDailyRequest) -> AnyPublisher<[SoccerMatchDailyResponse], NetworkError> {
        return Future<[SoccerMatchDailyResponse], NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            self.AFManager.request(MatchCalendarService.getDailySoccerMatches(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[SoccerMatchDailyResponse]>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? []))
                        }
                        // 응답 실패
                        else {
                            switch result.status {
                            case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 랭킹 조회 API
    func getRanking() -> AnyPublisher<[RankingResponse], NetworkError> {
        return Future<[RankingResponse], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MatchCalendarService.getRanking, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[RankingResponse]>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? []))
                        }
                        // 응답 실패
                        else {
                            switch result.status {
                            case 401:
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 경기 예측 버튼 클릭 조회 API
    func getPredictoinButtonClick(request: MatchIdRequest) -> AnyPublisher<PredictionButtonResponse, NetworkError> {
        return Future<PredictionButtonResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MatchCalendarService.getPredictionButton(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<PredictionButtonResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? PredictionButtonResponse(scorePredictions: ButtonMatchPredictionResponse(homePercentage: 0, awayPercentage: 0, isParticipated: false), lineupPredictions: ButtonLineupPredictionResponse(isParticipated: false))))
                        }
                        // 응답 실패
                        else {
                            switch result.status {
                            case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 선발라인업 조회 API
    func getStartingLineup(request: MatchIdRequest) -> AnyPublisher<StartingLineupResponse, NetworkError> {
        return Future<StartingLineupResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MatchCalendarService.getStartingLineup(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<StartingLineupResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data!))
                        }
                        // 응답 실패
                        else {
                            switch result.status {
                            case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
