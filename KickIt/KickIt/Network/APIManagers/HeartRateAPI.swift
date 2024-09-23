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
    func getHeartRateStatistics(request: HeartRateStatisticsRequest) -> AnyPublisher<HeartRateStatisticsResponse, NetworkError> {
        return Future<HeartRateStatisticsResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(HeartRateService.getHeartRateStatistics(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<HeartRateStatisticsResponse>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // FIXME: 백엔드에서 isSuccess값 보내주면, 이에 맞춰 로직 변경하기!
                        // 이거는 내가 어떻게 바꾸는지 알려줄게!!
                        switch result.status {
                        case 200:
                            return promise(.success(result.data!))
                        case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                            return promise(.failure(.authFailed))
                        case 400..<500: // 요청 실패
                            return promise(.failure(.requestErr(result.message)))
                        case 500: // 서버 오류
                            return promise(.failure(.serverErr(result.message)))
                        default: // 알 수 없는 오류
                            return promise(.failure(.unknown(result.message)))
                        }
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 사용자의 심박수 데이터 업로드 API
    func postUserHeartRate(teamName: String, min: Double, avg: Double, max: Double) -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                //promise(.failure(NetworkError.invalidResponse))
                return
            }
            AFManager.request(
                HeartRateService.postUserHeartRate(teamName: teamName, min: min, avg: avg, max: max)
            )
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {
                        //promise(.failure(NetworkError.invalidResponse))
                        return
                    }
//                    let result = self.judgeStatus(by: statusCode, Data(), Bool.self)
//                    switch result {
//                    case .success:
//                        promise(.success(true))
//                    case .requestErr(let errorCode):
//                        promise(.failure(NetworkError.requestError(errorCode)))
//                    case .pathErr:
//                        promise(.failure(NetworkError.pathError))
//                    case .serverErr:
//                        promise(.failure(NetworkError.serverError))
//                    case .networkFail:
//                        promise(.failure(NetworkError.networkFail))
//                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
