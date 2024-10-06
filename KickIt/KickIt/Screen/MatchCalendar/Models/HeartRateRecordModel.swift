//
//  HeartRateModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import HealthKit

// 심박수에 관한 모든 기능
class HeartRateRecordModel {
    private var healthStore = HKHealthStore()
    var HeartRateDates: [HeartRateDate] = []
    
    
    /// 심박수 권한 허용
    func authorizeHealthKit(completion: @escaping (Bool) -> Void) {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { success, error in
            completion(success)
            print("HealthKit authorization \(success ? "succeeded" : "failed")")
        }
    }
    
    /// 지정된 기간 동안의 심박수 데이터를 HealthKit에서 가져옴.
    /// - Parameters:
    ///   - startDate: 데이터 조회 시작 날짜
    ///   - endDate: 데이터 조회 종료 날짜
    ///   - completion: 데이터 로딩이 완료된 후 호출되는 클로저. 로드된 HeartRateDate 배열을 파라미터로 받습니다.
    func loadHeartRate(startDate: Date, endDate: Date, completion: @escaping ([HeartRateDate]) -> Void) {
        // HealthKit에서 심박수 데이터 타입 가져오기
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        // 지정된 기간 동안의 데이터만 조회하기 위한 조건 설정
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        // 데이터를 시간순으로 정렬하기 위한 설정
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        // HealthKit 쿼리 생성 및 실행
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] (_, results, error) in
            // 에러 체크 및 결과 타입 확인
            guard let samples = results as? [HKQuantitySample], error == nil else {
                print("Error loading heart rate data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 날짜 포맷터 설정
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            
            // 샘플들을 1분 단위로 그룹화
            let groupedSamples = Dictionary(grouping: samples) { sample -> String in
                dateFormatter.string(from: sample.startDate)
            }
            
            // 각 1분 그룹에서 최대 심박수 선택 및 HeartRateDate 객체 생성
            let records = groupedSamples.compactMap { (key, samples) -> HeartRateDate? in
                // 각 그룹에서 최대 심박수 찾기
                guard let maxSample = samples.max(by: { $0.quantity.doubleValue(for: .count().unitDivided(by: .minute())) < $1.quantity.doubleValue(for: .count().unitDivided(by: .minute())) }) else { return nil }
                
                // 심박수 값 추출 및 HeartRateDate 객체 생성
                let heartRate = Int(maxSample.quantity.doubleValue(for: .count().unitDivided(by: .minute())))
                return HeartRateDate(heartRate: heartRate, date: key)
            }
            
            // 로드된 데이터를 클래스 프로퍼티에 저장
            self?.HeartRateDates = records
            print("Loaded \(records.count) heart rate records")
            
            // 메인 스레드에서 완료 핸들러 호출
            DispatchQueue.main.async {
                completion(records)
            }
        }
        
        // 쿼리 실행
        healthStore.execute(query)
    }
    
    /// 특정 이벤트 시간에 대한 심박수 가져오기
    /// - Parameter eventTime: 이벤트 발생 시간 (형식: "yyyy/MM/dd HH:mm")
    /// - Returns: 이벤트 발생 5분 후 또는 가장 가까운 시간의 심박수
    func getHeartRate(for eventTime: String) -> Int? {
        print("Searching heart rate for event time: \(eventTime)")
        print("Available heart rate records: \(HeartRateDates)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        // 이벤트 시간을 Date 객체로 변환
        guard let eventDate = dateFormatter.date(from: eventTime) else {
            print("Failed to parse event date: \(eventTime)")
            return nil
        }
        
        // 이벤트 발생 5분 후의 시간 계산
        let fiveMinutesLater = eventDate.addingTimeInterval(5 * 60)
        
        // HeartRateDates 배열을 날짜순으로 정렬
        let sortedHeartRates = HeartRateDates.sorted { (a, b) -> Bool in
            guard let dateA = dateFormatter.date(from: a.date),
                  let dateB = dateFormatter.date(from: b.date) else {
                return false
            }
            return dateA < dateB
        }
        
        // 가장 가까운 심박수 기록 찾기
        var closestRecord: HeartRateDate?
        var smallestTimeDifference = Double.greatestFiniteMagnitude
        
        for record in sortedHeartRates {
            guard let recordDate = dateFormatter.date(from: record.date) else { continue }
            
            let timeDifference = abs(recordDate.timeIntervalSince(fiveMinutesLater))
            
            if timeDifference < smallestTimeDifference {
                smallestTimeDifference = timeDifference
                closestRecord = record
            }
            
            // 정확히 5분 후의 기록을 찾았거나, 5분을 넘어선 경우 루프 종료
            if timeDifference == 0 || recordDate > fiveMinutesLater {
                break
            }
        }
        
        
        // 결과 출력 및 반환
        if let record = closestRecord {
            print("Found heart rate \(record.heartRate) at \(record.date) for event time: \(eventTime)")
            return record.heartRate
        } else {
            print("No matching heart rate found for event time: \(eventTime)")
            return nil
        }
    }
}
