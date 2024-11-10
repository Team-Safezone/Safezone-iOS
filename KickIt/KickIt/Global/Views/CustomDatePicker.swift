//
//  CustomDatePicker.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 커스텀한 DatePicker(경기 캘린더, 일기 화면에서 사용)
struct CustomDatePicker: View {
    /// 현재 선택 중인 날짜
    @Binding var currentDate: Date
    
    /// 경기 날짜 리스트
    @Binding var matchDates: [Date]
    
    /// 현재 선택 중인 월 index
    @State var currentMonth: Int = 0 // default 0
    
    /// 로컬 캘린더 변수
    let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            /// 요일 리스트
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            // MARK: - 월 정보
            HStack(alignment: .center, spacing: 20) {
                // MARK: 이전 월로 변경하는 버튼
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.pretendard(.medium, size: 18))
                        .foregroundStyle(.gray500)
                }
                
                // MARK: 현재 월 정보
                Text("\(extractMonth())월")
                    .font(.pretendard(.medium, size: 18))
                    .foregroundStyle(.white0)
                
                // MARK: 다음 월로 변경하는 버튼
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.pretendard(.medium, size: 18))
                        .foregroundStyle(.gray500)
                }
            }
            
            // MARK: - 요일 정보
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.pretendard(.semibold, size: 13))
                        .foregroundStyle(.gray200)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 18)
            .padding(.horizontal, 27)
            
            // MARK: - 날짜 정보
            /// 날짜 열 리스트
            let dateColumns = Array(repeating: GridItem(.flexible()), count: 7)
            
            // 날짜 리스트 띄우기
            LazyVGrid(columns: dateColumns, spacing: 12) {
                ForEach(extractDate()) { date in
                    dateCardView(date: date) // 각 날짜 뷰
                        .frame(width: 38, height: 38)
                        // 경기 날짜가 아닌 날짜는 클릭 비활성화
                        .disabled(!matchDates.contains(date.date))
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 27)
        }
        // 월이 바뀌면 현재 선택 중인 날짜도 변경
        .onChange(of: currentMonth) { preDate, newDate in
            currentDate = currentMonthDates()
            print("date: \(currentDate.description)")
        }
    }
    
    /// 캘린더에 보여줄 날짜 뷰
    @ViewBuilder
    func dateCardView(date: CustomDate) -> some View {
        VStack(spacing: 0) {
            if (date.day != -1) {
                // 해당 날짜에 경기 일정이 있는지에 대한 여부 반환
                let isSoccerMatch = matchDates.contains { match in
                    return isSameDay(date1: match, date2: date.date)
                }
                
                // 오늘 날짜
                let isToday = isSameDay(date1: date.date, date2: Date())
                
                // 현재 선택 중인 날짜
                let isSelected = isSameDay(date1: date.date, date2: currentDate)
                
                ZStack {
                    // 해당 날짜에 경기 일정이 있다면
                    if isSoccerMatch {
                        // 해당 날짜가 오늘이라면
                        if isToday {
                            Circle()
                                .fill(isSelected ? .green0 : .gray900)
                                .stroke(.green0, lineWidth: 1)
                        }
                        else {
                            Circle()
                                .fill(isSelected ? .green0 : .gray900Assets)
                        }
                    }
                    // 해당 날짜에 경기 일정이 없다면
                    else {
                        // 해당 날짜가 오늘이라면
                        if isToday {
                            Circle()
                                .fill(.clear)
                                .stroke(.green0, lineWidth: 1)
                        }
                        else {
                            Circle()
                                .fill(.clear)
                        }
                    }
                    
                    // 날짜 텍스트
                    Text("\(date.day)")
                        .pretendardTextStyle(isSelected ? .SubTitleStyle : .Body2Style)
                        .foregroundStyle(dateTextColor(isSelected: isSelected, isToday: isToday))
                }
                // 다른 날짜 클릭 시, 날짜 색상&배경 바꾸기
                .background(
                    Circle()
                        .fill(isSameDay(date1: date.date, date2: currentDate) ? .green0 : .clear)
                )
                // 날짜 클릭 시, 현재 선택 중인 날짜 변경
                .onTapGesture {
                    var isMatch: Bool = false
                    for matchDate in matchDates {
                        if (matchDate == date.date) {
                            isMatch = true
                            break
                        }
                    }
                    
                    if isMatch {
                        currentDate = date.date
                    }
                }
            }
        }
        .frame(alignment: .top)
    }
    
    /// 날짜 텍스트 색상을 조건별로 반환하는 함수
    func dateTextColor(isSelected: Bool, isToday: Bool) -> Color {
        if isSelected {
            return .whiteAssets
        }
        else {
            return .gray500Text
        }
    }
    
    /// 현재 날짜 정보를 문자열로 반환하는 함수
    func extractMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        
        let date = formatter.string(from: currentDate)
        return date
    }
    
    /// 현재 월 정보를 반환하는 함수
    func currentMonthDates() -> Date {
        // 현재 선택 중인 월 계산
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date() // 계산된 날짜가 없는 경우
        }
        
        return currentMonth
    }
    
    /// 현재 월의 날짜 리스트를 반환하는 함수
    func extractDate() -> [CustomDate] {
        // 현재 선택 중인 월
        let currentMonth = currentMonthDates()
        
        // 현재 선택 중인 요일, 날짜 반환
        var days = currentMonth.monthDates().compactMap { date -> CustomDate in
            let day = calendar.component(.day, from: date) // 현재 날짜에서 요일 정보 가져오기
            
            return CustomDate(day: day, date: date)
        }
        
        // 정확한 일주일 시작 날짜를 얻기 위한 offset
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(CustomDate(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

/// 한 달 날짜 리스트 얻기
extension Date {
    func monthDates() -> [Date] {
        let calendar = Calendar.current // 로컬 캘린더 변수
        
        // 시작 날짜
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        // 시작 날짜 범위
        let dateRange = calendar.range(of: .day, in: .month, for: startDate)!
        
        // 날짜 1개씩 출력하기
        return dateRange.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

#Preview("경기 캘린더-달력") {
    MatchCalendar(viewModel: MatchCalendarViewModel())
}
