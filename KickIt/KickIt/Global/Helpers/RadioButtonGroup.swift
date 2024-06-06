//
//  RadioBtnGroup.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import SwiftUI

/// 라디오버튼 그룹
struct RadioButtonGroup: View {
    /// 라디오 버튼 텍스트 리스트
    var items: [String]
    
    @State var selectedId: Int = 0
    
    let callback: ((Int, Int)) -> ()
    
    func radioGroupCallback(id: Int) {
        callback((selectedId, id)) // 콜백, 이전&현재 선택한 버튼을 콜백
        selectedId = id // 선택한 버튼 아이디 정보 변경
    }
    
    var body: some View {
        LazyHStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                RadioButton(
                    id: index,
                    label: item,
                    callback: self.radioGroupCallback,
                    selectedId: self.selectedId
                )
            }
        }
    }
}
