//
//  MyPageAPI.swift
//  KickIt
//
//  Created by DaeunLee on 10/11/24.
//

import Foundation
import Combine
import Alamofire

// 마이페이지 메뉴에서 사용할 API
class MyPageAPI: BaseAPI {
    /// 경기 이벤트 전역 객체
    static let shared = MyPageAPI()
    
    // 초기화
    private override init() {
        super.init()
    }
    
    // MARK: - 사용자 데이터 GET API
    func getUserInfo() -> AnyPublisher<UserInfoResponse, NetworkError> {
        return Future<UserInfoResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(MyPageService.getUserInfo, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<UserInfoResponse>.self) { response in
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
    
    // MARK: - 닉네임 수정 POST API
    func updateNickname(request: NicknameUpdateRequest) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown("Network Error")))
                return
            }
            
            self.AFManager.request(MyPageService.updateNickname(request), interceptor: MyRequestInterceptor())
                .validate()
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
    
    // MARK: - 선호 팀 수정 POST API
    func updateFavoriteTeams(request: FavoriteTeamsUpdateRequest) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown("Network Error")))
                return
            }
            
            self.AFManager.request(MyPageService.updateFavoriteTeams(request), interceptor: MyRequestInterceptor())
                .validate()
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
