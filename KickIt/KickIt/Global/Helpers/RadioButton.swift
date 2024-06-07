//
//  RadioBtn.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import SwiftUI

/// 라디오 버튼
struct RadioButton: View {
    let id: Int
    let label: String
    let callback: (Int) -> ()
    let selectedId: Int
    
    init(id: Int, label: String, callback: @escaping (Int) -> Void, selectedId: Int) {
        self.id = id
        self.label = label
        self.callback = callback
        self.selectedId = selectedId
    }
    
    var body: some View {
        Button {
            self.callback(id)
        } label: {
            Text(label)
                .padding(.vertical, 6)
                .padding(.horizontal, 18)
        }
        .buttonStyle(
            DesignChip(
                labelColor: self.selectedId == self.id ? .black : .white,
                labelBGColor: self.selectedId == self.id ? .lime : .gray900
            )
        )
    }
}
