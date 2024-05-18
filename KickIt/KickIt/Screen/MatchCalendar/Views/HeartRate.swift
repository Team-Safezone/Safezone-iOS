//
//  HeartRate.swift
//  KickIt
//
//  Created by DaeunLee on 5/16/24.
//

import SwiftUI
import HealthKit

struct HeartRate: View {
    let view = ViewController()
    @State private var date: String = ""
    @State private var arrayHR: [[String: Any]] = []
    
    // Timer 객체 선언
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect() // 60초마다 업데이트
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            VStack {
                VStack (alignment: .center){
                    ForEach(arrayHR.indices, id: \.self) { index in
                        Text("Date: \(arrayHR[index]["Date"] ?? "")  HeartRate: \(arrayHR[index]["HeartRate"] ?? 0.0)")
                        Text("")
                    }
                }
            }
            .onReceive(timer) { _ in
                // Timer가 발생할 때마다 HeartRate를 다시 로드하고 arrayHR 업데이트
                view.loadHeartRate()
                arrayHR = view.arrayHR.reversed() // arrayHR 업데이트
                print("-------------------------------------")
                print("updated: \(Date())")
                print(arrayHR)
                print("-------------------------------------")
            }
            .onAppear {
                // HeartRate 로드 및 초기화
                view.authorizeHealthKit()
                arrayHR = view.arrayHR.reversed() // 초기화 시 arrayHR 업데이트
            }
        }
    }
}

#Preview {
    HeartRate()
}

