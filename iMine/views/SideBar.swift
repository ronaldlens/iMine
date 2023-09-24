//
//  SideBar.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI

struct SideBar: View {
    
    @Environment(DfData.self) private var dfData
    @Environment(ProcessOutline.self) private var processOutline
    
    var body: some View {
        if (processOutline.items.isEmpty) {
            Text("No processes to analyze")
        } else {
            List(processOutline.items, id: \.id, children: \.children) { item in
                Text(item.name)
            }.listStyle(.sidebar)
        }
    }
}

#Preview {
    SideBar()
}
