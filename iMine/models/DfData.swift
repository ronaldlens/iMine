//
//  DfData.swift
//  iMine
//
//  Created by Ronald Lens on 02/09/2023.
//

import Foundation
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

@Observable class DfData {
    static let shared = DfData()
    
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
    
   
}
