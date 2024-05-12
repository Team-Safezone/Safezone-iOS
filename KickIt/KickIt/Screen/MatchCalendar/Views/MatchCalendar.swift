//
//  EventCalendar.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 경기 일정 & 캘린더 화면
struct MatchCalendar: View {
    
    /// 현재 선택한 날짜
    @State var currentDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .topTrailing) {
                        
                        // MARK: - Custom Date Picker
                        CustomDatePicker(currentDate: $currentDate)
                        
                        // MARK: - 랭킹 화면으로 이동하는 버튼
                        Button {
                            
                        } label: {
                            Image(systemName: "trophy")
                                .font(.title2)
                                .foregroundStyle(.gray600)
                                .padding(.top, 8)
                                .padding(.trailing, 24)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MatchCalendar()
}
