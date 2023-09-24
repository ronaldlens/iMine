//
//  ViewState.swift
//  iMine
//
//  Created by Ronald Lens on 02/09/2023.
//

import Foundation
import Observation
import SwiftUI

enum WhatView {
    case nothing,
    dfPreview,
    metadata,
    processOutline
    
}

@Observable class CenterViewState: Identifiable {
    static let shared = CenterViewState()

    var id = UUID()
    var whatView: WhatView = .nothing
    var selectedColumn = ""
}

//extension EnvironmentValues {
//    var centerViewState: CenterViewState {
//        get { self[CenterViewStateKey.self] }
//        set { self[CenterViewStateKey.self] = newValue }
//    }
//}
//        
//        private struct CenterViewStateKey: EnvironmentKey {
//            static var defaultValue: CenterViewState = CenterViewState()
//        }
