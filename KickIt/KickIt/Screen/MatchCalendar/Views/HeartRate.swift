//
//  HeartRate.swift
//  KickIt
//
//  Created by DaeunLee on 5/16/24.
//

import SwiftUI
import HealthKit


struct HeartRate: View {
    var soccerMatch: SoccerMatch = dummySoccerMatches[0]
    let view = ViewController()
    @State private var arrayHR: [[String: Any]] = []
    
    // Timer 객체 선언
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var dataPoints: [CGFloat]
    @State var dataTime: [Int]
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                HStack{
                    Text("심박수 그래프")
                        .font(.Title1)
                    Spacer()
                    HStack(spacing: 6){
                        Text("\(Int(CGFloat(dataPoints.min() ?? 50.0 ))) ~ \(Int(CGFloat(dataPoints.max() ?? 120.0 )))")
                            .font(.Title1)
                        Text("BPM")
                            .font(.Body3)
                            .foregroundStyle(.gray800)
                    }}
                .padding(.horizontal, 16)
                .padding(.top, 30)
                LineChart(dataPoints: $dataPoints, dataTime: $dataTime, matchE: matchEvents.reversed())
                    .padding(.leading, 16)
                FanList()
                
                ViewerHRStats()
                    .padding(.top, 44)
                ViewerStats()
                
                
            }
            .onReceive(timer) { _ in
                updateHeartRateData()
            }
            NavigationLink{
                
            } label: {
                
            }
            .navigationTitle("경기 타임라인")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    func updateHeartRateData() {
        view.loadHeartRate()
        arrayHR = view.arrayHR.reversed()
        
        dataPoints = []
        dataTime = []
        
        for item in arrayHR {
            if let point = item["HeartRate"] as? Int, let date = item["Date"] as? String {
                dataPoints.append(CGFloat(point))
                dataTime.append(minutesExtracted(from: date)!)
            }
        }
    }
}

#Preview {
    HeartRate(dataPoints: [106.0, 105.0, 101.0, 108.0, 100.0, 113.0, 139.0, 127.0, 124.0, 122.0, 100.0, 99.0, 97.0, 94.0, 99.0, 93.0, 99.0, 107.0, 104.0, 97.0, 98.0, 99.0, 100.0, 100.0, 127.0, 117.0, 115.0, 113.0, 98.0, 109.0, 106.0, 100.0, 112.0, 103.0, 96.0, 97.0, 109.0], dataTime:  [2, 6, 11, 15, 19, 27, 32, 33, 34, 35, 37, 41, 47, 52, 57, 59, 61, 62, 63, 66, 71, 72, 75, 79, 84, 85, 86, 87, 93, 96, 102, 104, 109, 111, 115, 119, 120])
}
