//
//  HeartRateViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import Combine
import Foundation

class HeartRateViewModel: ObservableObject {
    @Published var dataPoints: [CGFloat] = []
    @Published var dataTime: [Int] = []
    @Published var arrayHR: [HeartRateRecord] = []
    @Published var homeTeamPercentage: Int = 0
    @Published var teamHeartRateData: HeartRateData?
    
    private var model = HeartRateModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        model.authorizeHealthKit { [weak self] success in
            if success {
                self?.updateHeartRateData()
            }
        }
    }
    
    /// 심박수 업데이트 함수
    func updateHeartRateData(useDummyData: Bool = false) {
        let startDate = Calendar.current.date(from: setStartTime()) ?? Date() // 경기 시작 날짜
        let endDate = Calendar.current.date(from: setEndTime()) ?? Date() // 경기 종료 날짜
        if useDummyData {
            self.arrayHR = DummyData.heartRateRecords
        } else {
            model.loadHeartRate(startDate: startDate, endDate: endDate) { [weak self] records in
                DispatchQueue.main.async {
                    self?.arrayHR = records.reversed()
                    self?.dataPoints = records.map { CGFloat($0.heartRate) }
                    self?.dataTime = records.compactMap { minutesExtracted(from: $0.date) }
                }
            }
        }
        
        /// 홈 팀 시청자 비율 조회 호출
        func fetchViewerPercentage(matchID: Int) {
            HeartRateAPI.shared.getViewerPercentage(matchID: matchID)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching viewer percentage: \(error)")
                    }
                }, receiveValue: { [weak self] percentage in
                    self?.homeTeamPercentage = percentage
                })
                .store(in: &cancellables)
        }
        
        /// 팀 별 심박수 데이터 조회
        func fetchTeamHeartRate(teamName: String) {
            HeartRateAPI.shared.getTeamHeartRate(teamName: teamName)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching team heart rate: \(error)")
                    }
                }, receiveValue: { [weak self] heartRateData in
                    self?.teamHeartRateData = heartRateData
                })
                .store(in: &cancellables)
        }
        
        /// 사용자의 심박수 데이터 업로드
        func uploadUserHeartRate(teamName: String, min: Double, avg: Double, max: Double) {
            HeartRateAPI.shared.postUserHeartRate(teamName: teamName, min: min, avg: avg, max: max)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error uploading user heart rate: \(error)")
                    }
                }, receiveValue: { success in
                    if success {
                        print("User heart rate uploaded successfully")
                    }
                })
                .store(in: &cancellables)
        }
    }
}
