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
    
    @State private var isAnalyzing = false
    
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
            id: "importFile",
            placement: .navigation,
            showsByDefault: true) {
                Button {
                    importDataFile(centerViewState: centerViewState, dfData: dfData)
                } label: {
                    Label("Import file", systemImage: "square.and.arrow.down")
                }
                .help("Import a CSV file")
            }
        ToolbarItem(
            id: "savedf",
            placement: .navigation,
            showsByDefault: true) {
                Button {
                    saveDataFile(dfData: dfData)
                } label: {
                    Label("Save dataframe", systemImage: "opticaldiscdrive")
                }
                .help("Save the current dataframe")
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
            id:"analyzeprocess",
            placement: .primaryAction,
            showsByDefault: true) {
                Button {
                    isAnalyzing.toggle()
                } label: {
                    Label("Analyze the events", systemImage: "network.badge.shield.half.filled")
                }
                .help("STart Event analysis into process")
                .sheet(isPresented: $isAnalyzing) {
                    ProcessAnalyzerSheet()
                    
                }
            }
        ToolbarItem(
            id: "overviewprocess",
            placement: .primaryAction,
            showsByDefault: true) {
                Button {
                    centerViewState.whatView = .processOutline
                } label: {
                    Label("Process outline", systemImage: "chart.xyaxis.line")
                }
                .help("Show process outline")
                
            }
        ToolbarItem(
            id: "processdiagram",
            placement: .primaryAction,
            showsByDefault: true) {
                Button {
                    centerViewState.whatView = .processdiagram
                } label: {
                    Label("Process outline", systemImage: "arrow.up.right.and.arrow.down.left.rectangle")
                }
                .help("Show process diagram")
                
            }
    }
    
    
    
    func toggleSidebar() {
        NSApp.keyWindow?
            .contentViewController?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
