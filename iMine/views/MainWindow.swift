//
//  ContentView.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI

struct MainWindow: View {
    var body: some View {
        NavigationView {
            SideBar()
                .frame(width: 200)
            CenterView(centerViewState: CenterViewState.shared)
        }
        .frame(
            minWidth: 700,
            idealWidth: 1000,
            maxWidth: .infinity,
            minHeight: 400,
            idealHeight: 800,
            maxHeight: .infinity)
        .navigationTitle("iMine")
        .toolbar(id: "mainToolbar") {
            Toolbar()
        }
    }
}

#Preview {
    MainWindow()
}
