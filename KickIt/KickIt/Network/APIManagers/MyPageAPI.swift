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
    
    /// 닉네임 중복 검사 API 호출
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.checkNicknameDuplicate(nickname), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Bool>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess {
                            promise(.success(result.isSuccess))
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
                        promise(.failure(.networkFail(error.localizedDescription)))
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
    
    /// 팀 목록을 가져오는 API 호출
    func getTeams() -> AnyPublisher<[SoccerTeam], NetworkError> {
        return Future<[SoccerTeam], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.getTeams, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: CommonResponse<[SoccerTeamResponse]>.self) { response in
                switch response.result {
                    // API 호출 성공
                case .success(let result):
                    if result.isSuccess, let data = result.data {
                        let teams = data.map { $0.toEntity() }
                        promise(.success(teams))
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
}
