//
//  DfData.swift
//  iMine
//
//  Created by Ronald Lens on 02/09/2023.
//

import SwiftUI
import Observation
import TabularData

struct ColumnMetadata : Identifiable {
    let id: UUID
    let name: String
    let wrappedType: String
    let totalCount: Int
    let missingCount: Int
    
    init(col: AnyColumn) {
        id = UUID()
        name = col.name
        let fullTypeString = String(describing: type(of: col.wrappedElementType))
        wrappedType = fullTypeString.replacingOccurrences(of: ".Type", with: "")
        totalCount = col.count
        missingCount = col.missingCount
    }
}

struct StringEntry: Identifiable {
    let id = UUID()
    let value: String
}

@Observable class DfData {
    
    var dataFrame: DataFrame? {
        didSet {
            updateMetadataFromDf()
        }
    }
    
    var columnMetadata: [ColumnMetadata] = []
    
    init(df: DataFrame? = nil) {
        self.dataFrame = df
        updateMetadataFromDf()
    }
    
    func updateMetadataFromDf() {
        columnMetadata = []
        if let df = self.dataFrame {
            for col in df.columns {
                columnMetadata.append(ColumnMetadata(col: col))
            }
        }
    }
    
    func renameColumn(from: String, to:String) {
        dataFrame?.renameColumn(from, to: to)
    }
    
    func dropColumn(name: String) {
        dataFrame?.removeColumn(name)
    }
    
    func getListFromColumn(name: String, noLines: Int) -> [StringEntry] {
        var result: [StringEntry] = []
        guard let dataFrame = dataFrame else { return result }
        let columnDf = dataFrame.selecting(columnNames: name)
        var count = 0
        for row in columnDf.rows {
            let str = "\(String(describing: row[name]))"
            let entry = StringEntry(value: str)
            result.append(entry)
            count += 1
            if (count == noLines) {
                break
            }
        }
        return result
    }
}

extension EnvironmentValues {
    var dfData: DfData {
        get { self[DfDataKey.self] }
        set { self[DfDataKey.self] = newValue }
    }
}

private struct DfDataKey: EnvironmentKey {
    static var defaultValue: DfData = DfData()
}
