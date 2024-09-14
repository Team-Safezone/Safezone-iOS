//
//  MatchEventAPI.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Alamofire
import Combine
import Foundation

class MatchEventAPI: BaseAPI {
    static let shared = MatchEventAPI()
    
    private override init() {}
    
    /// Returns dummy data instead of real API calls
    /// 0: 경기 시작, 1: 전반, 2: 휴식, 3: 후반, 4: 추가 선언, 5: 추가, 6:경기 종료
    func getMatchEvents(matchID: Int) -> AnyPublisher<[MatchEvent], Error> {
        return Future { promise in
            let dummyEvents = DummyData.matchEvents
            if dummyEvents.isEmpty {
                promise(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
            } else {
                promise(.success(dummyEvents))
            }
        }
        .eraseToAnyPublisher()
    }
    
//    func getMatchEvents(matchID: Int) -> AnyPublisher<[MatchEvent], Error> {
//        return Future { [weak self] promise in
//            guard let self = self else {
//                promise(.failure(NetworkError.invalidResponse))
//                return
//            }
//            
//            AlamoFireManager
//                .request(MatchEventService.getMatchEvents(matchID: matchID) as! URLRequestConvertible)
//                .responseDecodable(of: [MatchEvent].self) { response in
//                    switch response.result {
//                    case .success(let events):
//                        promise(.success(events))
//                    case .failure(let error):
//                        promise(.failure(error))
//                    }
//                }
//        }
//        .eraseToAnyPublisher()
//    }
}



