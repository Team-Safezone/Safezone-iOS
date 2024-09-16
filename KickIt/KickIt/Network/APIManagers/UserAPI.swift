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
    
    /// 사용자 닉네임 설정 API 호출
    /// - Parameter nickname: 설정할 닉네임
    /// - Returns: API 호출 결과를 나타내는 Publisher
    func setNickname(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.setNickname(nickname))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// 사용자 선호 팀 설정 API 호출
    /// - Parameter teams: 설정할 선호 팀 목록
    /// - Returns: API 호출 결과를 나타내는 Publisher
    func setFavoriteTeams(teams: [String]) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.setFavoriteTeams(teams))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// 마케팅 동의 설정 API 호출
    /// - Parameter consent: 마케팅 동의 여부
    /// - Returns: API 호출 결과를 나타내는 Publisher
    func setMarketingConsent(consent: Bool) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.setMarketingConsent(consent))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// 닉네임 중복 검사 API 호출
    /// - Parameter nickname: 검사할 닉네임
    /// - Returns: 중복 여부를 나타내는 Publisher
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.checkNicknameDuplicate(nickname))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// 제네릭 API 요청 메서드
    /// - Parameter target: API 요청 대상 서비스
    /// - Returns: API 응답을 나타내는 Publisher
    private func request<T: Codable>(_ target: UserService) -> AnyPublisher<CommonResponse<T>, Error> {
        return Future<CommonResponse<T>, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown("Self is nil")))
                return
            }
            
            self.AFManager.request(target, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<T>.self) { response in
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(NetworkError.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

