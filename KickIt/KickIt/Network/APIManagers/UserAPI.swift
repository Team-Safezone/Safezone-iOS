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
    
    /// 회원가입 API 호출
    /// - Parameter signUpData: 회원가입에 필요한 데이터
    /// - Returns: API 호출 결과를 나타내는 Publisher
    func signUp(signUpData: SignUpRequest) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.signUp(signUpData))
            .map { (response: CommonResponse<Bool>) in
                response.data ?? false
            }
            .mapError { $0 as? NetworkError ?? .unknown("Unknown error occurred") }
            .eraseToAnyPublisher()
    }
    
    /// 닉네임 중복 검사 API 호출
    /// - Parameter nickname: 검사할 닉네임
    /// - Returns: 중복 여부를 나타내는 Publisher
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return request(UserService.checkNicknameDuplicate(nickname))
            .map { $0.data ?? false }
            .eraseToAnyPublisher()
    }
    
    /// 팀 목록을 가져오는 API 호출
    /// - Returns: 팀 목록을 나타내는 Publisher
    func getTeams() -> AnyPublisher<[SoccerTeam], NetworkError> {
        return request(UserService.getTeams)
            .map { (response: CommonResponse<[SoccerTeamRequest]>) in
                (response.data ?? []).map { $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }
    
    /// 제네릭 API 요청 메서드
    /// - Parameter target: API 요청 대상 서비스
    /// - Returns: API 응답을 나타내는 Publisher
    private func request<T: Codable>(_ target: UserService) -> AnyPublisher<CommonResponse<T>, NetworkError> {
        return Future<CommonResponse<T>, NetworkError> { [weak self] promise in
            guard let self = self else {
                // self가 nil인 경우 에러 반환
                promise(.failure(.unknown("Self is nil")))
                return
            }
            
            self.AFManager.request(target, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<T>.self) { response in
                    switch response.result {
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result))
                        } else {
                            switch result.status {
                            case 401: // TODO: 토큰 오류 interceptor 코드 작동하는지 확인 후, 삭제해도 OK
                                return promise(.failure(.authFailed))
                            case 400..<500: // 요청 실패
                                return promise(.failure(.requestErr(result.message)))
                            case 500: // 서버 오류
                                return promise(.failure(.serverErr(result.message)))
                            default: // 알 수 없는 오류
                                return promise(.failure(.unknown(result.message)))
                            }
                        }
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
