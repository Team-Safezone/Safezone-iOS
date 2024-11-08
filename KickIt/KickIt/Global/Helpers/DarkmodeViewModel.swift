//
//  DarkmodeViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 11/8/24.
//

import Foundation
import SwiftUI

// 다크모드 설정
class DarkmodeViewModel: ObservableObject{
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
}

