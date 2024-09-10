//
//  LineChartView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

/// 심박수 통계 화면의 심박수 그래프
struct LineChartView: View {
    @Binding var dataPointsChart: [CGFloat]
    @Binding var dataTimeChart: [Int]
    var matchEvents: [MatchEvent]
    
    @State private var boxEventViewModel: BoxEventViewModel?
    @State private var pathPosition = CGPoint(x: 0, y: 0)
    @State private var isDragging = false
    
    var body: some View {
        let maxData = dataPointsChart.max() ?? 1.0
        let minData = dataPointsChart.min() ?? 0.0
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .bottomLeading) {
                // Y축 및 눈금선 디자인
                VStack(spacing: 44) {
                    let lineNum = (Int(maxData) - Int(minData)) / 3
                    Text("높음\n\(Int(maxData) - lineNum) BPM")
                    Text("보통\n\(Int(minData) + lineNum) BPM")
                    Text("낮음\n\(Int(minData)) BPM")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                // 라인 그래프
                let points = normalizedDataPoints(maxDataPoint: maxData, minDataPoint: minData)
                Path { path in
                    path.move(to: CGPoint(x: 64, y: 220))
                    path.addLines(points)
                }
                .stroke(Color.green, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .padding(.leading, 64)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.isDragging = true
                            self.pathPosition = value.location
                            updateBoxEventViewModel()
                        }
                        .onEnded { _ in
                            self.isDragging = false
                            self.boxEventViewModel = nil
                        }
                )
                
                // BoxEventView
                if let viewModel = boxEventViewModel,
                   let event = viewModel.event,
                   !(event.eventCode == 0 || event.eventCode == 2 || event.eventCode == 4 || event.eventCode == 6) {
                    BoxEventView(viewModel: viewModel)
                        .position(x: pathPosition.x, y: -40)
                }
                
                // 드래그 라인
                if isDragging {
                    Path { path in
                        path.move(to: CGPoint(x: pathPosition.x, y: 220))
                        path.addLine(to: CGPoint(x: pathPosition.x, y: 0))
                    }
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                }
            }
            .padding(.top, 80)
            .frame(width: 600, height: 302)
            
            HStack(alignment: .center, spacing: 30) {
                let xAxisLabels = ["0분", "15분", "30분", "45분", "60분", "75분", "90분"]
                ForEach(xAxisLabels, id: \.self) { label in
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 60)
            .padding(.top, 5)
        }
    }
    
    private func normalizedDataPoints(maxDataPoint: CGFloat, minDataPoint: CGFloat) -> [CGPoint] {
        let yRange = maxDataPoint - minDataPoint
        let spacing = 220 / yRange
        
        var points: [CGPoint] = []
        
        for (index, dataPoint) in dataPointsChart.enumerated() {
            let xPosition = CGFloat((dataTimeChart[index] * 56) / 15)
            let yPosition = 220 - (dataPoint - minDataPoint) * spacing
            points.append(CGPoint(x: xPosition, y: yPosition))
        }
        
        return points
    }
    
    private func updateBoxEventViewModel() {
            let calculatedTime = Int(round((pathPosition.x - 64) * 15 / 56))
            let dataRange = (dataPointsChart.max() ?? 1) - (dataPointsChart.min() ?? 0)
            let normalizedY = (200 - pathPosition.y) / 200
            let lineHR = (normalizedY * dataRange) + (dataPointsChart.min() ?? 0)
            
            if let event = matchEvents.first(where: { $0.eventTime == calculatedTime }) {
                boxEventViewModel = BoxEventViewModel(dataPoint: lineHR, time: calculatedTime, event: event, homeTeamEmblemURL: event.teamUrl)
            } else {
                boxEventViewModel = BoxEventViewModel(dataPoint: lineHR, time: calculatedTime)
            }
        }
    }

struct BoxEventView: View {
    @ObservedObject var viewModel: BoxEventViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                if let event = viewModel.event {
                    HStack(spacing: 4) {
                        if let emblemURL = viewModel.homeTeamEmblemURL {
                            LoadableImage(image: emblemURL)
                                .frame(width: 24, height: 24)
                                .background(.white)
                                .clipShape(Circle())
                        }
                        Text("\(event.player1) \(event.eventName)")
                            .pretendardTextStyle(.SubTitleStyle)
                    }
                } else {
                    Text("이벤트 없음")
                        .pretendardTextStyle(.Body2Style)
                }
                Spacer()
                Text("\(viewModel.time)분")
                    .pretendardTextStyle(viewModel.event != nil ? .SubTitleStyle : .Body2Style)
            }
            .foregroundStyle(.black0)
            .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(Int(viewModel.dataPoint))")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.lime)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(80)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.green0)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(75)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.violet)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(width: 234, height: 80, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.gray900)
        }
    }
}



#Preview {
    LineChartView(dataPointsChart: .constant([]), dataTimeChart: .constant([]), matchEvents: DummyData.matchEvents)
}


#Preview {
    BoxEventView(viewModel: BoxEventViewModel(dataPoint: 72, time: 8))
}
