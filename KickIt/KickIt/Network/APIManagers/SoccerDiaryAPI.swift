//
//  SoccerDiaryAPI.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation
import Alamofire
import Combine

class SoccerDiaryAPI: BaseAPI {
    /// 전역 객체
    static let shared = SoccerDiaryAPI()
    
    private override init() {
        super.init()
    }
    
    /// 추천 축구 일기 조회
    func getRecommendDiary() -> AnyPublisher<[RecommendDiaryResponse], NetworkError> {
        return Future<[RecommendDiaryResponse], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.getRecommendDiary, interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[RecommendDiaryResponse]>.self) { response in
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
