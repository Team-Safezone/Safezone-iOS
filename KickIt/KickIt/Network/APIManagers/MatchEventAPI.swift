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
    func getMatchEvents(request: MatchEventsRequest) -> AnyPublisher<[MatchEventsData], NetworkError> {
        return Future<[MatchEventsData], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            // API 호출
            self.AFManager.request(MatchEventService.getMatchEvents(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[MatchEventsData]>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess, let data = result.data {
                            promise(.success(data))
                        } else {
                            let error: NetworkError
                            switch result.status {
                            case 401:
                                error = .authFailed
                            case 400..<500:
                                error = .requestErr(result.message)
                            case 500:
                                error = .serverErr(result.message)
                            default:
                                error = .unknown(result.message)
                            }
                            promise(.failure(error))
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
    
    /// 사용자 평균 심박수 API
    func getUserAverageHeartRate() -> AnyPublisher<Int, NetworkError> {
        return Future<Int, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MatchEventService.getUserAverageHeartRate, interceptor: MyRequestInterceptor())
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
    
    /// 사용자 심박수 데이터 존재 확인 API
    func checkHeartRateDataExists(matchId: Int64) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            let request = MatchEventService.checkHeartRateDataExists(matchId: matchId)
            
            self.AFManager.request(request, interceptor: MyRequestInterceptor())
                .validate()
                .responseData { response in
                    print("Response Status Code: \(response.response?.statusCode ?? -1)")
                    print("Response Headers: \(response.response?.allHeaderFields ?? [:])")
                    
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Response Body: \(str)")
                    }
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let result = try JSONDecoder().decode(CommonResponse<Bool>.self, from: data)
                            if result.isSuccess {
                                promise(.success(result.data ?? false))
                            } else {
                                print("Server Error Message: \(result.message)")
                                switch result.status {
                                case 401:
                                    promise(.failure(.authFailed))
                                case 400..<500:
                                    promise(.failure(.requestErr(result.message)))
                                case 500:
                                    promise(.failure(.serverErr(result.message)))
                                default:
                                    promise(.failure(.unknown(result.message)))
                                }
                            }
                        } catch {
                            print("Decoding Error: \(error)")
                        }
                    case .failure(let error):
                        print("Network Error: \(error.localizedDescription)")
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
