//
//  CenterView.swift
//  iMine
//
//  Created by Ronald Lens on 01/09/2023.
//

import SwiftUI

struct CenterView: View {
    var centerViewState: CenterViewState
    
   
    var body: some View {
        switch centerViewState.whatView {
        case .nothing:
            Text(" ")
        case .dfPreview:
           DfPreview()
        case .metadata:
            MetadataView()
        }
    }
}

#Preview {
    CenterView(centerViewState: CenterViewState.shared)
}