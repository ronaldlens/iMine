//
//  Toolbar.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI

struct Toolbar: CustomizableToolbarContent {
    @Environment(CenterViewState.self) private var centerViewState
    @Environment(DfData.self) private var dfData
    
    var body: some CustomizableToolbarContent {
        ToolbarItem(
            id: "toggleSidebar",
            placement: .navigation,
            showsByDefault: true) {
                Button {
                    toggleSidebar()
                } label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
                .help("Toggle sidebar")
            }
        ToolbarItem(
            id: "showheader",
            placement: .primaryAction,
            showsByDefault: true ) {
                Button {
                    centerViewState.whatView = .metadata
                } label: {
                    Label("Show metadata", systemImage: "list.dash.header.rectangle")
                }
                .help("Show dataframe metadata")
            }
        ToolbarItem(
            id: "showdftable",
            placement: .primaryAction,
            showsByDefault: true ) {
                Button {
                    centerViewState.whatView = .dfPreview
                } label: {
                    Label("Show dataframe table", systemImage: "tablecells.fill.badge.ellipsis")
                }
                .help("Show dataframe table")
        }
        ToolbarItem(
        id: "importFile",
        placement: .primaryAction,
        showsByDefault: true) {
            Button {
                importDataFile(centerViewState: centerViewState, dfData: dfData)
            } label: {
                Label("Import file", systemImage: "square.and.arrow.down")
            }
            .help("Import a CSV file")
        }
    }
    
    
    
    func toggleSidebar() {
        NSApp.keyWindow?
            .contentViewController?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
