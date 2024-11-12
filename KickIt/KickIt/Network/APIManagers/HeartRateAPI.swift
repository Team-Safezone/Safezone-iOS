//
//  HeartRateAPI.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation
import Alamofire
import Combine

/// 심박수 통계 API
class HeartRateAPI: BaseAPI {
    /// 심박수 통계 전역 객체
    static let shared = HeartRateAPI()
    
    private override init() {
        super.init()
    }
    
    /// 심박수 통계 조회 API
    func getHeartRateStatistics(matchId: Int64) -> AnyPublisher<HeartRateStatisticsResponse, NetworkError> {
        return Future<HeartRateStatisticsResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(HeartRateService.getHeartRateStatistics(matchId: matchId), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<HeartRateStatisticsResponse>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess, let data = result.data {
                            promise(.success(data))
                        } else {
                            print("Server Error Message: \(result.message)")
                            switch result.status {
                            case 401:
                                return promise(.failure(.authFailed))
                            case 400..<500:
                                return promise(.failure(.requestErr(result.message)))
                            case 500:
                                return promise(.failure(.serverErr(result.message)))
                            default:
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
