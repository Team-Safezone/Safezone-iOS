//
//  LineChartView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

/// 심박수 통계 화면의 심박수 그래프
struct LineChartView: View {
    @ObservedObject var viewModel: HeartRateViewModel
    
    var body: some View {
        let allHeartRates = viewModel.userHeartRates +
        (viewModel.statistics?.homeTeamHeartRateRecords ?? []) +
        (viewModel.statistics?.awayTeamHeartRateRecords ?? [])
        let maxData = allHeartRates.map { $0.heartRate }.max() ?? 1.0
        let minData = allHeartRates.map { $0.heartRate }.min() ?? 0.0
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .bottomLeading) {
                    // Y축 및 눈금선 디자인
                    VStack(spacing: 44) {
                        let lineNum = (Int(maxData) - Int(minData)) / 3
                        Text("높음\n\(Int(maxData) - lineNum) BPM")
                        Text("보통\n\(Int(minData) + lineNum) BPM")
                        Text("낮음\n\(Int(minData)) BPM")
                    }
                    .pretendardTextStyle(.Caption1Style)
                    .foregroundColor(.gray200)
                    
                    // 실선 및 점선 추가
                    VStack(alignment: .leading, spacing: 80) {
                        // 높음 - 점선
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 600, y: 0))
                        }
                        .stroke(Color.gray800, style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                        .frame(width: 420, height: 1)
                        
                        // 보통 - 점선
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 600, y: 0))
                        }
                        .stroke(Color.gray800, style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                        .frame(width: 420, height: 1)
                        
                        // 낮음 - 실선
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 600, y: 0))
                        }
                        .stroke(Color.gray800, style: StrokeStyle(lineWidth: 1))
                        .frame(width: 420, height: 1)
                    }.padding(.leading, 64)
                    
                    // 라인 그래프
                    Group {
                        drawLine(for: viewModel.userHeartRates, color: .lime)
                        drawLine(for: viewModel.statistics?.homeTeamHeartRateRecords ?? [], color: .green0)
                        drawLine(for: viewModel.statistics?.awayTeamHeartRateRecords ?? [], color: .violet)
                    }
                    .padding(.leading, 64)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.location.x >= 64 && value.location.x <= geometry.size.width {
                                    viewModel.isDragging = true
                                    viewModel.pathPosition = value.location
                                    viewModel.updateBoxEventViewModel(at: value.location, in: geometry.size)
                                }
                            }
                            .onEnded { _ in
                                viewModel.endDragging()
                            }
                    )
                    
                    // BoxEventView
                    if viewModel.isDragging, let boxViewModel = viewModel.boxEventViewModel {
                        BoxEventView(viewModel: boxViewModel)
                            .position(x: viewModel.pathPosition.x, y: -40)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 382, height: 80)
                            .foregroundStyle(.gray950)
                            .overlay{
                                Text("그래프를 드래그하여 이벤트를 확인해보세요!")
                                    .pretendardTextStyle(.SubTitleStyle)
                                    .foregroundStyle(.gray500Text)
                            }.position(x: geometry.size.width / 2 - 8, y: -40)
                            .padding(.bottom, 4)
                    }
                        
                    
                    
                    // 드래그 라인
                    if viewModel.isDragging {
                        Path { path in
                            path.move(to: CGPoint(x: viewModel.pathPosition.x, y: 220))
                            path.addLine(to: CGPoint(x: viewModel.pathPosition.x, y: 0))
                        }
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                    }
                }
                .padding(.top, 80)
                .frame(width: 600, height: 302)
                
                // 그래프 x축
                HStack(alignment: .center, spacing: 30) {
                    let xAxisLabels = ["0분", "15분", "30분", "45분", "60분", "75분", "90분"]
                    ForEach(xAxisLabels, id: \.self) { label in
                        Text(label)
                            .font(.pretendard(.medium, size: 12))
                            .foregroundColor(.gray500Text)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
                .padding(.top, 5)
            }.frame(width: 400)
        }
    }
    
    // 그래프 그리기
    private func drawLine(for heartRates: [HeartRateRecord], color: Color) -> some View {
        let points = normalizedDataPoints(for: heartRates)
        return Path { path in
            if let firstPoint = points.first {
                path.move(to: firstPoint)
                path.addLines(points)
            }
        }
        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
    
    // 심박수 수치를 그래프에 맞추기
    private func normalizedDataPoints(for heartRates: [HeartRateRecord]) -> [CGPoint] {
        let allHeartRates = viewModel.userHeartRates +
        (viewModel.statistics?.homeTeamHeartRateRecords ?? []) +
        (viewModel.statistics?.awayTeamHeartRateRecords ?? [])
        let maxDataPoint = allHeartRates.map { $0.heartRate }.max() ?? 1.0
        let minDataPoint = allHeartRates.map { $0.heartRate }.min() ?? 0.0
        let yRange = maxDataPoint - minDataPoint
        let spacing = 220 / yRange
        
        return heartRates.map { record in
            let xPosition = CGFloat((record.date * 56) / 15)
            let yPosition = 220 - (record.heartRate - minDataPoint) * spacing
            return CGPoint(x: xPosition, y: yPosition)
        }
    }
}

// LineChart 드래그시 나타나는 BoxEventView
struct BoxEventView: View {
    @ObservedObject var viewModel: BoxEventViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                if let event = viewModel.event {
                    if viewModel.event!.eventName != "경기시작", viewModel.event!.eventName != "추가선언", viewModel.event!.eventName != "하프타임" {
                        HStack(spacing: 4) {
                            if let emblemURL = viewModel.homeTeamEmblemURL {
                                LoadableImage(image: emblemURL)
                                    .frame(width: 24, height: 24)
                                    .background(.white0)
                                    .clipShape(Circle())
                            }
                            Text("\(event.player1 ?? "")")
                                .pretendardTextStyle(.Title2Style)
                            Text("\(event.eventName)")
                                .pretendardTextStyle(.Body1Style)
                        }
                    }
                } else {
                    Text("이벤트 없음")
                        .pretendardTextStyle(.Body1Style)
                }
                Spacer()
                Text("\(viewModel.time)분")
                    .pretendardTextStyle(.SubTitleStyle)
            }
            .foregroundStyle(.white0)
            .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                if viewModel.dataPoint > 0 {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("\(Int(viewModel.dataPoint))")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.lime)
                        Text("BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500Text)
                    }
                }
                
                if viewModel.homeTeamHR > 0 {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("\(viewModel.homeTeamHR)")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.green0)
                        Text("BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500Text)
                    }
                }
                
                if viewModel.awayTeamHR > 0 {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("\(viewModel.awayTeamHR)")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.violet)
                        Text("BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500Text)
                    }
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

#Preview("그래프") {
    LineChartView(viewModel: HeartRateViewModel.withDummyData())
}

#Preview("박스") {
    BoxEventView(viewModel: BoxEventViewModel(dataPoint: 100, time: 30, homeTeamHR: 40, awayTeamHR: 70))
}

