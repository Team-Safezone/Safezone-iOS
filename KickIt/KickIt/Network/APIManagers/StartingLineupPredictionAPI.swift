//
//  StartingLineupPredictionAPI.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation
import Alamofire
import Combine

/// 선발라인업 화면에서 사용하는 API
class StartingLineupPredictionAPI: BaseAPI {
    /// 선발라인업 전역 객체
    static let shared = StartingLineupPredictionAPI()
    
    private override init() {
        super.init()
    }
    
    /// 선발라인업 예측 API
    func postStartingLineupPrediction(query: MatchIdRequest, request: StartingLineupPredictionRequest) -> AnyPublisher<PredictionFinishResponse, NetworkError> {
        return Future<PredictionFinishResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(StartingLineupPredictionService.postStartingLineupPrediction(query, request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<PredictionFinishResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? PredictionFinishResponse(grade: 0, point: 0)))
                        } else {
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 선발라인업 예측 조회 API
    func getDefaultStartingLineupPrediction(request: MatchIdRequest) -> AnyPublisher<StartingLineupPredictionDefaultResponse, NetworkError> {
        return Future<StartingLineupPredictionDefaultResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(StartingLineupPredictionService.getDefaultStartingLineupPrediction(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<StartingLineupPredictionDefaultResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data!))
                        } else {
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
