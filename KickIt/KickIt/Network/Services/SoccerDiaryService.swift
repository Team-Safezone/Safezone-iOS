//
//  SoccerDiaryService.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation
import Alamofire
import SwiftUI

/// 축구 일기 Router
enum SoccerDiaryService {
    // 추천 축구 일기 조회 API
    case getRecommendDiary(Int)
    
    // 내 축구 일기 조회 API
    case getMyDiary(Int)
    
    // 축구 일기 신고하기 API
    case postNotifyDiary(Int64, DiaryNotifyRequest)
    
    // 축구 일기 좋아요 이벤트 API
    case patchLikeDiary(Int64, DiaryLikeRequest)
    
    // 축구 일기 삭제 이벤트 API
    case deleteDiary(Int64)
    
    // 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회 API
    case getSelectSoccerDiaryMatch(SoccerMatchMonthlyRequest)
    
    /// 축구 일기 작성 때 보여줄 최고 BPM 조회
    case getSoccerDiaryMaxHeartRate(Int64)
    
    /// 축구 일기 작성 URL
    case createSoccerDiary(CreateSoccerDiaryRequest, [MultipartFormFile]?)
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
        case .getSelectSoccerDiaryMatch:
            return .get
        case .getSoccerDiaryMaxHeartRate:
            return .get
        case .createSoccerDiary:
            return .post
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
        case .getSelectSoccerDiaryMatch:
            return APIConstants.selectSoccerDiaryMatchURL
        case .getSoccerDiaryMaxHeartRate:
            return APIConstants.getSoccerDiaryMaxHeartRateURL
        case .createSoccerDiary:
            return APIConstants.createSoccerDiaryURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getRecommendDiary(let path):
            return .path(String(path))
        case .getMyDiary(let path):
            return .path(String(path))
        case .postNotifyDiary(let diaryId, let data):
            return .pathBody(String(diaryId), data)
        case .patchLikeDiary(let diaryId, let data):
            return .pathBody(String(diaryId), data)
        case .deleteDiary(let path):
            return .path(String(path))
        case .getSelectSoccerDiaryMatch(let query):
            return .query([
                "yearMonth" : query.yearMonth,
                "teamName" : query.teamName
            ])
        case .getSoccerDiaryMaxHeartRate(let path):
            return .path(String(path))
        case .createSoccerDiary(let data, let files):
            return .multipart(data, files)
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
        case .getSelectSoccerDiaryMatch:
            return .basic
        case .getSoccerDiaryMaxHeartRate:
            return .basic
        case .createSoccerDiary:
            return .multiPart
        }
    }
}
