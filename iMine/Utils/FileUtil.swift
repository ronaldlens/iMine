//
//  FileImporter.swift
//  iMine
//
//  Created by Ronald Lens on 31/08/2023.
//

import SwiftUI
import TabularData

func importDataFile(centerViewState: CenterViewState, dfData: DfData) {
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

func saveDataFile(dfData: DfData) {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.commaSeparatedText]

    let response = savePanel.runModal()
    if response != .OK {
        return
    }
    guard let saveURL = savePanel.url else { return }
    do {
        try dfData.dataFrame?.writeCSV(to: saveURL)
    } catch {
        print(error)
    }
}
