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
        // UserService에서 setNickname 호출하고, 응답 데이터를 CommonResponse<Bool>로 매핑
        return request(UserService.setNickname(nickname))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false // 응답 데이터가 nil인 경우 false 반환
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription) // 네트워크 에러 처리
            }
            .eraseToAnyPublisher() // 반환 타입을 AnyPublisher로 변환
    }
    
    /// 사용자 선호 팀 설정 API 호출
    /// - Parameter teams: 설정할 선호 팀 목록
    /// - Returns: API 호출 결과를 나타내는 Publisher
    func setFavoriteTeams(teams: [String]) -> AnyPublisher<Bool, NetworkError> {
        // 선호 팀 목록 설정을 위한 API 요청
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
        // 닉네임 중복 여부 확인을 위한 API 호출
        return request(UserService.checkNicknameDuplicate(nickname))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { error in
                NetworkError.networkFail(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// 팀 목록을 가져오는 API 호출
    /// - Returns: 팀 목록을 나타내는 Publisher
    func getTeams() -> AnyPublisher<[SoccerTeam], NetworkError> {
        // 팀 목록을 가져오기 위한 API 호출
        return request(UserService.getTeams)
            .map { (response: CommonResponse<[SoccerTeam]>) in
                response.data ?? []
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
        // API 요청을 보내고, 응답을 비동기적으로 처리하는 메서드
        return Future<CommonResponse<T>, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown("Self is nil")))
                return
            }
            
            self.AFManager.request(target, interceptor: MyRequestInterceptor())
                .validate() // 응답 검증
                .responseDecodable(of: CommonResponse<T>.self) { response in
                    switch response.result {
                    case .success(let result):
                        promise(.success(result)) // 성공 시 데이터를 promise에 전달
                    case .failure(let error):
                        promise(.failure(NetworkError.networkFail(error.localizedDescription))) // 실패 시 에러 전달
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

