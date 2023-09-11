//
//  ViewState.swift
//  iMine
//
//  Created by Ronald Lens on 02/09/2023.
//

import Foundation
import Observation

enum WhatView {
    case nothing,
    dfPreview,
    metadata
    
}

@Observable class CenterViewState {
    static let shared = CenterViewState()

    var whatView: WhatView = .nothing

    private init() {
        
    }
    
}
