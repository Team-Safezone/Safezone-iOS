//
//  ViewController.swift
//  KickIt
//
//  Created by DaeunLee on 5/16/24.
//

import UIKit
import HealthKit
class ViewController: UIViewController{
    
    let healthStore = HKHealthStore()
    
    @Published var latestHR: Double = 0
    @Published var date: String = ""
    @Published var arrayHR: [[String: Any]] = []
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    
    // MARK: 경기 시작 시간
    func setTime(){
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 5
        dateComponents.day = 12
        dateComponents.hour = 21
        dateComponents.minute = 20
        dateComponents.second = 0
        
        if arrayHR.isEmpty {
            self.startDate = Calendar.current.date(from: dateComponents) ?? Date()
            self.endDate = Date()
            print("초기 시간 설정: \(self.startDate) - \(self.endDate)")
        } else {
            self.startDate = self.endDate
            self.endDate = Date()
            print("시간 수정: \(self.startDate) - \(self.endDate)")
        }
        
    }
    
    // MARK: view 로드 시 가장 먼저 진행되는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizeHealthKit()
    }
    
    // MARK: get authorize HealthKIt
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
            if success {
                print("Authorization succeeded.")
                self.loadHeartRate()
            } else {
                print("Authorization failed. Error: \\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // MARK: fetch HeartRates
    func loadHeartRate(){
        self.setTime()
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: self.startDate, end: self.endDate, options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){ (sample, result, error) in
            guard error == nil else {
                return
            }
            
            // 데이터 parsing
            for record in result?.reversed() ?? [] {
                let data = record as! HKQuantitySample
                
                let dateFormator = DateFormatter()
                dateFormator.dateFormat = "yyyy/MM/dd hh:mm"
                self.date = dateFormator.string(from: data.endDate)
                
                let unit = HKUnit(from: "count/min")
                self.latestHR = data.quantity.doubleValue(for: unit)
                
                self.saveHRData(latestHR: self.latestHR, date: self.date)
            }
        }
        healthStore.execute(query)
    }
    
    
    // MARK: 심박수 데이터 편집
    func saveHRData(latestHR: Double, date: String) {
        let newRecord = ["HeartRate": latestHR, "Date": date] as [String : Any]
        
        /// 배열이 비어 있는 경우: 새로운 딕셔너리를 추가하고 종료
        guard !arrayHR.isEmpty else {
            arrayHR.append(newRecord)
            print("생성: \(arrayHR)")
            return
        }
        
        /// 새로운 데이터의 시간과 일치할 때, 심박수가 높을 때만 저장함
        let arrayIndex = arrayHR.firstIndex(where: { $0["Date"] as? String == newRecord["Date"] as? String})
        let arrayValue = arrayHR[arrayIndex ?? 0]["HeartRate"]
        if (arrayIndex != nil) {
            print("배열 index: \(arrayIndex ?? 0), \(arrayHR[arrayIndex ?? 0]["HeartRate"] ?? 0) -> \(newRecord["HeartRate"] ?? 0)")
            if newRecord["HeartRate"] as! Double > arrayValue as! Double {
                arrayHR[arrayIndex!]["HeartRate"] = newRecord["HeartRate"]
                print("수정: \(arrayHR)")
            } else {
                print("변동 없음")
                return
            }
        } else {
            arrayHR.append(newRecord)
            print("변화: \(arrayHR)")
        }
    }
}
