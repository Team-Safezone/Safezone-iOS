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
    let callback: (Int, String) -> Void
    let selectedId: Int
    
    var body: some View {
        Button {
            self.callback(id, label)
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
