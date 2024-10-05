//
//  AvgHeartRateAPI.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Combine
import Alamofire

// 사용자 평균 심박수 API
class AvgHeartRateAPI: BaseAPI {
    
    static let shared = AvgHeartRateAPI()
    
    // 초기화
    private override init() {
        super.init()
    }
    
    /// 사용자 평균 심박수 API
    func getUserAverageHeartRate() -> AnyPublisher<Int, NetworkError> {
        return Future<Int, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(AvgHeartRateService.getUserAverageHeartRate, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<AvgHeartRateResponse>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess, let data = result.data {
                            promise(.success(data.avgHeartRate))
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
                        if let statusCode = response.response?.statusCode {
                            print("Request failed with status code: \(statusCode)")
                        }
                        print("Error Description: \(error.localizedDescription)")
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
