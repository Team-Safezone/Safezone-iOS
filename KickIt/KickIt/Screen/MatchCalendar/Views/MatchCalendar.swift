//
//  MatchCalendar.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 경기 일정 & 캘린더 화면
struct MatchCalendar: View {
    
    /// 현재 선택한 날짜
    @State var currentDate: Date = Date()
    
    /// 경기 클릭 상태 여부
    @State private var isMatchSelected = false
    
    /// 클릭한 경기 정보
    @State private var selectedMatch: SoccerMatch?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .topTrailing) {
                        
                        // MARK: - Custom Date Picker
                        CustomDatePicker(currentDate: $currentDate) { match in
                            selectedMatch = match
                            isMatchSelected = true
                        }
                        
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
            .navigationDestination(isPresented: $isMatchSelected) {
                if let match = selectedMatch {
                    SoccerMatchInfo(soccerMatch: match)
                        .toolbarRole(.editor) // back 텍스트 숨기기
                        .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                }
            }
        }
    }
}

#Preview {
    MatchCalendar()
}
