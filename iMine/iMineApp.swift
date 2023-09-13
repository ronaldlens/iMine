//
//  iMineApp.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI

@main
struct iMineApp: App {
    @State private var centerViewState = CenterViewState()
    @State private var dfData = DfData()
    
    var body: some Scene {
        WindowGroup {
            MainWindow()
                .environment(\.centerViewState, centerViewState)
                .environment(\.dfData, dfData)
        }
        .commands {
            Menus()
        }
    }
}
