//
//  LineChart.swift
//  KickIt
//
//  Created by DaeunLee on 5/31/24.
//

import SwiftUI



/// 심박수 통계 라인 그래프
struct LineChart: View {
    /// 라인 그래프에 들어갈 데이터
    @Binding var dataPoints: [CGFloat]
    @Binding var dataTime: [Int]
    var matchE: [MatchEvent] = matchEvents.reversed()
    
    /// path의 현재 위치를 저장
    @State private var pathPosition = CGPoint(x: 0, y: 0)
    @State private var isDragging = false
    
    
    private func normalizedDataPoints(maxDataPoint: CGFloat, minDataPoint: CGFloat) -> [CGPoint] {
        let yRange = maxDataPoint - minDataPoint
        let spacing = 220 / yRange
        
        var points: [CGPoint] = []
        
        for (index, dataPoint) in dataPoints.reversed().enumerated() {
            let xPosition = CGFloat((dataTime[index] * 56)/15)
            let yPosition = (220 - (dataPoint - (minDataPoint)) * spacing)
            //            if xPosition < 63 { xPosition = 64}
            //            if yPosition < 0{ yPosition = 0 }
            points.append(CGPoint(x: xPosition, y: yPosition))
            
        }
        
        return points
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .bottomLeading) {
                // MARK: Y축
                VStack(spacing: 44){
                    let lineNum = (Int(CGFloat(dataPoints.max() ?? 1)) - Int(CGFloat(dataPoints.min() ?? 0))) / 3
                    Text("높음\n\(Int(CGFloat(dataPoints.max() ?? 0))-lineNum) BPM")
                    Text("보통\n\(Int(CGFloat(dataPoints.min() ?? 0))+lineNum) BPM")
                    Text("낮음\n\(Int(CGFloat(dataPoints.min() ?? 0))) BPM")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray400)
                
                //MARK: 눈금선 디자인
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 220 / 3 * CGFloat(1)))
                    path.addLine(to: CGPoint(x: 450, y: 220 / 3 * CGFloat(1)))
                }
                .stroke(.gray400, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [4.0]))
                .padding(.leading, 64)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 220 / 3 * CGFloat(2)))
                    path.addLine(to: CGPoint(x: 450, y: 220 / 3 * CGFloat(2)))
                }
                .stroke(.gray400, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [4.0]))
                .padding(.leading, 64)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 220 / 3 * CGFloat(3)))
                    path.addLine(to: CGPoint(x: 450, y: 220 / 3 * CGFloat(3)))
                }
                .stroke(.gray400, style: StrokeStyle(lineWidth: 1, lineCap: .round))
                .padding(.leading, 64)
                
                
                // MARK: 라인그래프
                Path { path in
                    let points = normalizedDataPoints(maxDataPoint: dataPoints.max() ?? 1, minDataPoint: dataPoints.min() ?? 0)
                    path.move(to: CGPoint(x: 64, y: 220))
                    path.addLines(points)
                    let _ = print("line updated:::  \(points)")
                    
                }
                .stroke(Color.gray600, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .padding(.leading, 64)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            self.isDragging = true
                            self.pathPosition = value.location
                        }
                        .onEnded{ _ in
                            self.isDragging = false
                        })
                
                
                
                // MARK: 드래그 이벤트
                if CGFloat(62) < pathPosition.x && pathPosition.x < CGFloat(dataTime.last ?? 120) * CGFloat(56)/CGFloat(15)+62 && pathPosition.y < 221 {
                    let eventTimes = matchE.map { $0.eventTime }
                    let calculatedTime = Int(round((pathPosition.x - 64) * 15 / 56))
//                    let pathIndex = dataTime.firstIndex(where: { $0 == calculatedTime })
                    let dataRange = (dataPoints.max() ?? 1) - (dataPoints.min() ?? 0)
                    let normalizedY = (200 - pathPosition.y) / 200
                    let lineHR = (normalizedY * dataRange) + (dataPoints.min() ?? 0)
                    
                    if let timeIndex = eventTimes.firstIndex(where: { $0 == calculatedTime }) {
                        BoxEvent(dataPoint: lineHR, event: matchE[timeIndex])
                            .position(x:pathPosition.x, y: -40)
                    } else {
                        BoxEvent2(dataPoint: lineHR, time: calculatedTime)
                            .position(x:pathPosition.x, y: -40)
                    }
                    Path{ path in
                        path.move(to: CGPoint(x: pathPosition.x, y: 220))
                        path.addLine(to: CGPoint(x: pathPosition.x, y: 0))
                    }
                    .stroke(.gray400, style: StrokeStyle(lineWidth: 1))
                }
                
                
            }
            .padding(.top, 80)
            .frame(width: 600, height: 302)
            
            HStack(alignment: .center, spacing: 30){
                let xAxisLables:[String] = ["0분", "15분", "30분", "45분", "60분", "75분", "90분"]
                ForEach(xAxisLables, id: \.self) { label in
                    Text(label)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.gray600)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 60)
            .padding(.top, 5)
        }
    }
}

#Preview {
    LineChart(dataPoints: .constant([]), dataTime: .constant([]), matchE: matchEvents.reversed())
}
