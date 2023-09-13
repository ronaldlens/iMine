//
//  DfPreview.swift
//  iMine
//
//  Created by Ronald Lens on 11/09/2023.
//

import SwiftUI

struct DfPreview: View {
    @Environment(\.dfData) private var dfData
    
    var body: some View {
        VStack {
            Text("Loaded data")
                .font(.title)
                .multilineTextAlignment(.center)
            let table = dfData.dataFrame?.description
            ScrollView(.horizontal) {
                Text(table!)
                    .frame(maxWidth: .infinity)
                    .font(.system(.caption, design: .monospaced))
            }
            .scrollClipDisabled(true)
            
        }
    }
}

#Preview {
    DfPreview()
}
