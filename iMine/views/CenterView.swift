//
//  CenterView.swift
//  iMine
//
//  Created by Ronald Lens on 01/09/2023.
//

import SwiftUI

struct CenterView: View {
    @Environment(CenterViewState.self) private var centerViewState
   
   
    var body: some View {
        VStack {
            switch centerViewState.whatView {
            case .nothing:
                Text("")
            case .dfPreview:
                DfPreview()
            case .metadata:
                MetadataView()
            case .processOutline:
                ProcessOutlineView()
            case .processdiagram:
                ProcesDiagramView()
            
            }
            Spacer()
            StatusBar()
                .frame(alignment: .bottom)
        }
    }
}

#Preview {
    CenterView()
}
