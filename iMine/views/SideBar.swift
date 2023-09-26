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
    @Environment(CenterViewState.self) private var centerViewState
    
    @State private var selection: UUID? = nil
    
    var body: some View {
        if (processOutline.items.isEmpty) {
            Text("No processes to analyze")
        } else {
            VStack {
                List(processOutline.items, id: \.id, children: \.children, selection: $selection) { item in
                    Text(item.name)
                }.listStyle(.sidebar)
                    .frame(maxWidth: .infinity)
                    .onChange(of: selection) {
                        if let selection = selection {
                            if let outLineItem = processOutline.findItemById(id: selection) {
                                centerViewState.selectedOutlineItem = outLineItem
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    SideBar()
}
