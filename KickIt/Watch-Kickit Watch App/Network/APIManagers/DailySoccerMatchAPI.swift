//
//  DailySoccerMatchAPI.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 11/5/24.
//

import Combine
import Alamofire
import Foundation

/// 경기 캘린더 화면에서 사용하는 API
class DailySoccerMatchAPI: BaseAPI {
    static let shared = DailySoccerMatchAPI()
    
    private override init() {
        super.init()
    }
    
    /// 하루 경기 일정 조회 API
    func getDailySoccerMatches(request: SoccerMatchDailyRequest) -> AnyPublisher<[SoccerMatchDailyResponse], NetworkError> {
            return Future<[SoccerMatchDailyResponse], NetworkError> { [weak self] promise in
                guard let self = self else {
                    promise(.failure(.pathErr))
                    return
                }
                self.AFManager.request(SoccerMatchService.getDailySoccerMatches(request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[SoccerMatchDailyResponse]>.self) { response in
                    switch response.result {
                        // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.data ?? []))
                        }
                        // 응답 실패
                        else {
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
