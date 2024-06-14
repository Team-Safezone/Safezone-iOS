//
//  HomeAPI.swift
//  KickIt
//
//  Created by 이윤지 on 6/14/24.
//

import Alamofire
import Combine
import Foundation

/// 홈 화면에서 사용하는 API
class HomeAPI: BaseAPI {
    static let shared = HomeAPI()
    
    private override init() {
        super.init()
    }
    
    /// 프리미어리그 팀 리스트 조회 API
    func getSoccerTeams(soccerSeason: String) ->
    AnyPublisher<[SoccerTeam], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            AlamoFireManager.request(
                HomeService.getSoccerTeams(soccerSeason: soccerSeason)
            )
            .responseData { response in
                switch response.result {
                    // 응답 받기 성공
                case .success(let soccerTeams):
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    let result = self.judgeStatus(by: statusCode, soccerTeams, [SoccerTeamResponseModel].self)
                    switch result {
                        // 성공
                    case .success(let teamDTO):
                        // 전달받은 데이터를 앱 내부 데이터 타입으로 변환
                        let teams = teamDTO.map { dto in
                            SoccerTeam(
                                ranking: dto.ranking,
                                teamEmblemURL: dto.teamEmblemURL,
                                teamName: dto.teamName
                            )
                        }
                        promise(.success(teams))
                    
                    // 실패
                    // 요청 에러
                    case .requestErr(let errorMessage):
                        promise(.failure(NetworkError.requestError(errorMessage)))
                    // 경로 에러
                    case .pathErr:
                        promise(.failure(NetworkError.pathError))
                    // 서버 내부 에러
                    case .serverErr:
                        promise(.failure(NetworkError.serverError))
                    // 네트워크 에러
                    case .networkFail:
                        promise(.failure(NetworkError.networkFail))
                    }
                // 응답 받기 실패
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
