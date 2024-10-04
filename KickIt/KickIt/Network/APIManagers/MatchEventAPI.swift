//
//  MatchEventAPI.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation
import Alamofire
import Combine

/// 경기 이벤트 API
class MatchEventAPI: BaseAPI {
    /// 경기 이벤트 전역 객체
    static let shared = MatchEventAPI()
    
    // 초기화
    private override init() {
        super.init()
    }
    
    /// 경기 이벤트 GET API
    func getMatchEvents(request: MatchEventsRequest) -> AnyPublisher<MatchEventsResponse, NetworkError> {
        return Future<MatchEventsResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            // API 호출
            self.AFManager.request(MatchEventService.getMatchEvents(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<MatchEventsResponse>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess {
                            promise(.success(result.data!))
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
    
    // 사용자 심박수 데이터 존재 확인 API
    func checkHeartRateDataExists(request: HeartRateDataExistsRequest) -> AnyPublisher<HeartRateDataExistsResponse, NetworkError> {
        return Future<HeartRateDataExistsResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            // API 호출
            self.AFManager.request(MatchEventService.checkHeartRateDataExists(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<HeartRateDataExistsResponse>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess {
                            promise(.success(result.data!))
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
    
    // 사용자 심박수 POST API
    func postMatchHeartRate(request: MatchHeartRateRequest) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown("Network Error")))
                return
            }
            AFManager.request(
                MatchEventService.postMatchHeartRate(request) as! URLConvertible,
                method: .post,
                parameters: request,
                encoder: JSONParameterEncoder.default
            )
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.unknown("Invalid Response")))
                        return
                    }
                    if 200...299 ~= statusCode {
                        promise(.success(()))
                    } else {
                        promise(.failure(NetworkError.unknown("Server Error")))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
