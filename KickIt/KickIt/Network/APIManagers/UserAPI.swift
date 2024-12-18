//
//  UserAPI.swift
//  KickIt
//
//  Created by DaeunLee on 9/16/24.
//

import Combine
import Alamofire

/// 사용자 관련 API 요청을 처리하는 클래스
class UserAPI: BaseAPI {
    
    static let shared = UserAPI()
    
    private override init() {
        super.init()
    }
    
    /// 카카오 회원가입 API 호출
    func kakaoSignUp(request: KakaoSignUpRequest) -> AnyPublisher<String, NetworkError> {
        return Future<String, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.kakaoSignUp(request))
                .validate()
                .responseDecodable(of: CommonResponse<String>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess {
                            promise(.success(result.data ?? ""))
                        }
                        else {
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
    
    /// 카카오 로그인 API 호출
    func kakaoLogin(request: KakaoLoginRequest) -> AnyPublisher<String, NetworkError> {
        return Future<String, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.kakaoLogin(request))
                .validate()
                .responseDecodable(of: CommonResponse<String>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess {
                            promise(.success(result.data ?? ""))
                        }
                        else {
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
    
    /// 닉네임 중복 검사 API 호출
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.checkNicknameDuplicate(nickname))
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
    
    /// 팀 목록을 가져오는 API 호출
    func getTeams() -> AnyPublisher<[SoccerTeam], NetworkError> {
        return Future<[SoccerTeam], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(UserService.getTeams) //interceptor: MyRequestInterceptor()
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
