//
//  HomeAPI.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import Foundation
import Alamofire
import Combine

/// 홈 화면에서 사용하는 API
class HomeAPI: BaseAPI {
    /// 홈 전역 객체
    static let shared = HomeAPI()
    
    private override init() {
        super.init()
    }
    
    /// 홈 화면 조회 API
    func getHome() -> AnyPublisher<HomeResponse, NetworkError> {
        return Future<HomeResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                // 잘못된 요청
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(HomeService.getHome, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<HomeResponse>.self) { response in
                    switch response.result {
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data!))
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
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
