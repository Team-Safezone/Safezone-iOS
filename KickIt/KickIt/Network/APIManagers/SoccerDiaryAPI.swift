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
    func getRecommendDiary(requestNum: Int) -> AnyPublisher<[RecommendDiaryResponse], NetworkError> {
        return Future<[RecommendDiaryResponse], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.getRecommendDiary(requestNum), interceptor: MyRequestInterceptor())
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
    
    /// 내 축구 일기 조회
    func getMyDiary(requestNum: Int) -> AnyPublisher<[MyDiaryResponse], NetworkError> {
        return Future<[MyDiaryResponse], NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.getMyDiary(requestNum), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<[MyDiaryResponse]>.self) { response in
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
    
    /// 축구 일기 신고하기
    func postNotifyDiary(diaryId: Int64, request: DiaryNotifyRequest) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.postNotifyDiary(diaryId, request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Bool>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.isSuccess))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 축구 일기 좋아요 클릭 이벤트
    func patchLikeDiary(diaryId: Int64, request: DiaryLikeRequest) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.patchLikeDiary(diaryId, request), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Bool>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.isSuccess))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 축구 일기 삭제 이벤트
    func deleteDiary(diaryId: Int64) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.deleteDiary(diaryId), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Bool>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.isSuccess))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회
    func getSelectSoccerDiaryMatch(query: SoccerMatchMonthlyRequest) -> AnyPublisher<SelectSoccerDiaryMatchResponse, NetworkError> {
        return Future<SelectSoccerDiaryMatchResponse, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.getSelectSoccerDiaryMatch(query), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<SelectSoccerDiaryMatchResponse>.self) { response in
                    switch response.result {
                        // API 호출 성공
                        case .success(let result):
                            // 응답 성공
                            if result.isSuccess {
                                promise(.success(result.data ?? SelectSoccerDiaryMatchResponse(isLeftExist: false, isRightExist: true)))
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
    
    /// 축구 일기 작성 때 보여줄 최고 BPM 조회
    func getSoccerDiaryMaxHeartRate(matchId: Int64) -> AnyPublisher<Int?, NetworkError> {
        return Future<Int?, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.getSoccerDiaryMaxHeartRate(matchId), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Int?>.self) { response in
                    switch response.result {
                        // API 호출 성공
                        case .success(let result):
                            // 응답 성공
                            if result.isSuccess {
                                promise(.success(result.data ?? nil))
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
    
    /// 축구 일기 작성
    func createSoccerDiary(request: CreateSoccerDiaryRequest, files: [MultipartFormFile]?) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.pathErr))
                return
            }
            
            self.AFManager.request(SoccerDiaryService.createSoccerDiary(request, files), interceptor: MyRequestInterceptor())
                .validate()
                .responseDecodable(of: CommonResponse<Bool>.self) { response in
                    switch response.result {
                    // API 호출 성공
                    case .success(let result):
                        // 응답 성공
                        if result.isSuccess {
                            promise(.success(result.isSuccess))
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
                    // API 호출 실패
                    case .failure(let error):
                        promise(.failure(.networkFail(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
