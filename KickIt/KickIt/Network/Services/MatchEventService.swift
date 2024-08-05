//
//  MatchEventService.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Alamofire
import Foundation

enum MatchEventService {
    case getMatchEvents(matchID: Int)
}

extension MatchEventService {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMatchEvents:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMatchEvents(let matchID):
            return "/matchEvents/\(matchID)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getMatchEvents:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        return .basic
    }
}
