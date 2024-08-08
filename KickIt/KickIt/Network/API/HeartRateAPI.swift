//
//  HeartRateAPI.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Alamofire
import Combine
import Foundation

/// 심박수 데이터를 위한 구조체
struct HeartRateData: Codable {
    let min: Double
    let avg: Double
    let max: Double
}

/// 심박수 통계 API
class HeartRateAPI: BaseAPI {
    static let shared = HeartRateAPI()
    
    private override init() {
        super.init()
    }
    
    /// 홈 팀 시청자 비율 조회 API
    func getViewerPercentage(matchID: Int) -> AnyPublisher<Int, Error> {
            Future { [weak self] promise in
                guard let self = self else {
                    promise(.failure(NetworkError.invalidResponse))
                    return
                }
                self.AlamoFireManager.request(
                    HeartRateService.getViewerPercentage(matchID: matchID)
                )
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let statusCode = response.response?.statusCode else {
                            promise(.failure(NetworkError.invalidResponse))
                            return
                        }
                        let result = self.judgeStatus(by: statusCode, data, Int.self)
                        switch result {
                        case .success(let percentage):
                            promise(.success(percentage))
                        case .requestErr(let errorCode):
                            promise(.failure(NetworkError.requestError(errorCode)))
                        case .pathErr:
                            promise(.failure(NetworkError.pathError))
                        case .serverErr:
                            promise(.failure(NetworkError.serverError))
                        case .networkFail:
                            promise(.failure(NetworkError.networkFail))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    /// 팀 별 심박수 데이터 조회 API
    func getTeamHeartRate(teamName: String) -> AnyPublisher<HeartRateData, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            AlamoFireManager.request(
                HeartRateService.getTeamHeartRate(teamName: teamName)
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    let result = self.judgeStatus(by: statusCode, data, HeartRateData.self)
                    switch result {
                    case .success(let heartRateData):
                        promise(.success(heartRateData))
                    case .requestErr(let errorCode):
                        promise(.failure(NetworkError.requestError(errorCode)))
                    case .pathErr:
                        promise(.failure(NetworkError.pathError))
                    case .serverErr:
                        promise(.failure(NetworkError.serverError))
                    case .networkFail:
                        promise(.failure(NetworkError.networkFail))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 사용자의 심박수 데이터 업로드 API
    func postUserHeartRate(teamName: String, min: Double, avg: Double, max: Double) -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            AlamoFireManager.request(
                HeartRateService.postUserHeartRate(teamName: teamName, min: min, avg: avg, max: max)
            )
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    let result = self.judgeStatus(by: statusCode, Data(), Bool.self)
                    switch result {
                    case .success:
                        promise(.success(true))
                    case .requestErr(let errorCode):
                        promise(.failure(NetworkError.requestError(errorCode)))
                    case .pathErr:
                        promise(.failure(NetworkError.pathError))
                    case .serverErr:
                        promise(.failure(NetworkError.serverError))
                    case .networkFail:
                        promise(.failure(NetworkError.networkFail))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
