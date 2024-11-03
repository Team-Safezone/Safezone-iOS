//
//  CircleRadioGroup.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import SwiftUI

/// 동그라미 라디오버튼 그룹
struct CircleRadioGroup: View {
    /// 라디오버튼 텍스트 리스트
    var items: [String]
    
    /// 선택한 라디오버튼 id
    @Binding var selectedId: Int
    
    /// 선택한 옵션 이름
    @Binding var selectedOption: String
    
    let callback: (Int, Int, String) -> Void
    
    func radioGroupCallback(_ id: Int, _ option: String) {
        callback(selectedId, id, option)
        selectedId = id
        selectedOption = option
    }
    
    var body: some View {
        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
            CircleRadioButton(
                id: index,
                label: item,
                callback: self.radioGroupCallback,
                selectedId: self.selectedId
            )
        }
    }
}
