//
//  ViewModelIphone.swift
//  KickIt
//
//  Created by DaeunLee on 5/10/24.
//

import Foundation
import WatchConnectivity

class ViewModelIPhone: NSObject, WCSessionDelegate, ObservableObject {
    
    func viewDidLoad() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // 필수 추가 함수
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // 워치에서 보낸 데이터 수신
    private func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler reply: @escaping (NSDictionary?) -> Void) {
        
    }
    
    
}
