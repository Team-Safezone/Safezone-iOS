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

    /// 심박수 로딩
    func loadHeartRate(startDate: Date, endDate: Date, completion: @escaping ([HeartRateDate]) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { [weak self] (_, results, error) in
            guard let samples = results as? [HKQuantitySample], error == nil else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            let groupedRecords = Dictionary(grouping: samples) { sample in
                dateFormatter.string(from: sample.endDate)
            }
            
            let records = groupedRecords.map { (key, samples) -> HeartRateDate in
                let maxHeartRate = samples.max { a, b in
                    a.quantity.doubleValue(for: HKUnit(from: "count/min")) < b.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }!
                
                let heartRate = Int(maxHeartRate.quantity.doubleValue(for: HKUnit(from: "count/min")))
                return HeartRateDate(heartRate: Int(CGFloat(heartRate)), date: key)
            }
            
            self?.HeartRateDates = records
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }

    /// 심박수 가져오기
    func getHeartRate(for eventTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        guard let eventDate = dateFormatter.date(from: eventTime) else { return nil }
        let fiveMinutesLater = eventDate.addingTimeInterval(5 * 60)
        
        return HeartRateDates
            .compactMap { record -> (Date, Int)? in
                guard let recordDate = dateFormatter.date(from: record.date ?? "") else { return nil }
                return (recordDate, Int(record.heartRate))
            }
            .filter { $0.0 <= fiveMinutesLater }
            .max(by: { $0.0 < $1.0 })?
            .1
    }
}
