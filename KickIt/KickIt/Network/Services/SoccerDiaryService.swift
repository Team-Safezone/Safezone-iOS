//
//  SoccerDiaryService.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation
import Alamofire

/// 축구 일기 Router
enum SoccerDiaryService {
    // 추천 축구 일기 조회 API
    case getRecommendDiary(Int)
    
    // 내 축구 일기 조회 API
    case getMyDiary
    
    // 축구 일기 신고하기 API
    case postNotifyDiary(DiaryNotifyRequest)
    
    // 축구 일기 좋아요 이벤트 API
    case patchLikeDiary(DiaryLikeRequest)
    
    // 축구 일기 삭제 이벤트 API
    case deleteDiary(DiaryDeleteRequest)
}

extension SoccerDiaryService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getRecommendDiary:
            return .get
        case .getMyDiary:
            return .get
        case .postNotifyDiary:
            return .post
        case .patchLikeDiary:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }
    
    var endPoint: String {
        switch self {
        case .getRecommendDiary:
            return APIConstants.recommendDiaryURL
        case .getMyDiary:
            return APIConstants.myDiaryURL
        case .postNotifyDiary:
            return APIConstants.notifyDiaryURL
        case .patchLikeDiary:
            return APIConstants.likeDiaryURL
        case .deleteDiary:
            return APIConstants.deleteDiaryURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getRecommendDiary(let path):
            return .path(String(path))
        case .getMyDiary:
            return .requestPlain
        case .postNotifyDiary(let data):
            return .queryBody(data.diaryId, data.reasonCode)
        case .patchLikeDiary(let data):
            return .queryBody(data.diaryId, data.isLiked)
        case .deleteDiary(let data):
            return .requestBody(data.diaryId)
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getRecommendDiary:
            return .basic
        case .getMyDiary:
            return .basic
        case .postNotifyDiary:
            return .basic
        case .patchLikeDiary:
            return .basic
        case .deleteDiary:
            return .basic
        }
    }
}
