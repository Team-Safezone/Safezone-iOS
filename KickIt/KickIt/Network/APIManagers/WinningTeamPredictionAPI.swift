//
//  WinningTeamPredictionAPI.swift
//  KickIt
//
//  Created by 이윤지 on 11/6/24.
//

import Foundation
import Alamofire
import Combine

/// 우승팀 예측 화면에서 사용하는 API
class WinningTeamPredictionAPI: BaseAPI {
    static let shared = WinningTeamPredictionAPI()
    
    private override init() {
        super.init()
    }
    
    /// 우승팀 예측 API
    func postWinningTeamPrediction(query: MatchIdRequest, request: WinningTeamPredictionRequest) -> AnyPublisher<PredictionFinishResponse, NetworkError> {
        return Future<PredictionFinishResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(WinningTeamPredictionService.postWinningTeamPrediction(query, request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<PredictionFinishResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? PredictionFinishResponse(grade: 0, point: 0)))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 우승팀 예측 결과 조회 API
    func getWinningTeamPredictionResult(request: MatchIdRequest) -> AnyPublisher<WinningTeamPredictionResultResponse, NetworkError> {
        return Future<WinningTeamPredictionResultResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(WinningTeamPredictionService.getWinningTeamPredictionResult(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<WinningTeamPredictionResultResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? WinningTeamPredictionResultResponse(participant: 0)))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
