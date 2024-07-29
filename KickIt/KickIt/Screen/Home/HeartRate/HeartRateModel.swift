//
//  HeartRateModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import Foundation
import HealthKit

struct HeartRateRecord {
    let heartRate: Int
    let date: String
}

class HeartRateModel {
    private var healthStore = HKHealthStore()
    var arrayHR: [HeartRateRecord] = []

    func authorizeHealthKit(completion: @escaping (Bool) -> Void) {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { success, error in
            completion(success)
            let _ = print("Authorization successed")
        }
    }

    func loadHeartRate(startDate: Date, endDate: Date, completion: @escaping ([HeartRateRecord]) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { [weak self] (sample, result, error) in
            guard error == nil else {
                return
            }
            
            var records: [HeartRateRecord] = []
            
            for record in result?.reversed() ?? [] {
                let data = record as! HKQuantitySample
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                let date = dateFormatter.string(from: data.endDate)
                let unit = HKUnit(from: "count/min")
                let heartRate = Int(data.quantity.doubleValue(for: unit))
                
                records.append(HeartRateRecord(heartRate: heartRate, date: date))
            }
            
            self?.arrayHR = records
            DispatchQueue.main.async {
                    completion(records)
                }
        }
        
        healthStore.execute(query)
    }
}
