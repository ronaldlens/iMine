//
//  FileImporter.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI
import TabularData

func importFile(centerViewState: CenterViewState, dfData: DfData) {
    let openPanel = NSOpenPanel()
    openPanel.allowedContentTypes = [.commaSeparatedText]
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    if response != .OK {
        return
    }
    if let url = openPanel.url {
        let options = CSVReadingOptions()
        do {
            dfData.dataFrame = try DataFrame(
                contentsOfCSVFile: url,
                options: options)
            dfData.updateMetadataFromDf()
            centerViewState.whatView = .metadata
        } catch {
            print("Error: \(error)")
            return
        }
    }
    

    
}
