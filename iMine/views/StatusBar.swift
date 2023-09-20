//
//  StatusBar.swift
//  iMine
//
//  Created by Ronald Lens on 18/09/2023.
//

import SwiftUI

struct StatusBar: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeStr = ""
    
    var body: some View {
        ZStack {
            Color(.lightGray)
            HStack {
                Spacer()
                Text(timeStr)
                    .onReceive(timer) { time in
                        timeStr = getProcessSize()
                    }
                Text(" ")
            }
        }
        .frame(maxHeight: 20, alignment: .bottom)
    }
}

#Preview {
    StatusBar()
}
