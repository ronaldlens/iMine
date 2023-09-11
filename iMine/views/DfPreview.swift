//
//  DfPreview.swift
//  iMine
//
//  Created by Ronald Lens on 11/09/2023.
//

import SwiftUI

struct DfPreview: View {
    
    let dfData = DfData.shared
    
    var body: some View {
        VStack {
            Text("Loaded data")
                .font(.title)
                .multilineTextAlignment(.center)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    DfPreview()
}
