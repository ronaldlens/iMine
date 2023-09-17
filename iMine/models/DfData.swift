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
    
    var dataFrame: DataFrame?
    
    var columnMetadata: [ColumnMetadata]
    
    var preview: String
    
    init(df: DataFrame? = nil) {
        self.columnMetadata = []
        self.dataFrame = df
        self.preview = ""
        updateMetadataFromDf()
    }
    
    func updateMetadataFromDf() {
        var newColumnMetadata: [ColumnMetadata] = []
        if let df = self.dataFrame {
            for col in df.columns {
                newColumnMetadata.append(ColumnMetadata(col: col))
            }
        }
        self.columnMetadata = newColumnMetadata
        self.preview = dataFrame?.description ?? ""
        
    }
    
    func renameColumn(from: String, to:String) {
        dataFrame?.renameColumn(from, to: to)
        updateMetadataFromDf()
    }
    
    func dropColumn(name: String) {
        dataFrame?.removeColumn(name)
        updateMetadataFromDf()
    }
    
    func getListFromColumn(name: String, noLines: Int) -> [StringEntry] {
        var result: [StringEntry] = []
        guard let dataFrame = dataFrame else { return result }
        let columnDf = dataFrame.selecting(columnNames: name)
        var count = 0
        for row in columnDf.rows {
            let str = "\(String(describing: row[name]!))"
            let entry = StringEntry(value: str)
            result.append(entry)
            count += 1
            if (count == noLines) {
                break
            }
        }
        return result
    }
    
    func convertColumnStringToDate(name: String, format: String) {
        guard var dataFrame = dataFrame else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let newColumn: Column<Date> = dataFrame[name, String.self].map { element in
            let str = element!
            return dateFormatter.date(from: str)!
        }
        dataFrame.replaceColumn(name, with: newColumn)
        self.dataFrame = dataFrame
        updateMetadataFromDf()
    }
    
    func dropRowsWithNilInColumn(name: String) {
        guard var dataFrame = dataFrame else { return }
        let newDf = dataFrame.filter(on: name, String.self, { $0 != nil })
        self.dataFrame = DataFrame(newDf)
        updateMetadataFromDf()
    }
}

