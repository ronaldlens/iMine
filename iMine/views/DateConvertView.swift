//
//  DateConvertDialog.swift
//  iMine
//
//  Created by Ronald Lens on 11/09/2023.
//

import SwiftUI

struct DateConvertView: View {
    @Environment(\.centerViewState) private var centerViewState
    @Environment(\.dfData) private var dfData
    
    var body: some View {
        let columnName = centerViewState.selectedColumn
        let datesToConvert = dfData.getListFromColumn(name: columnName, noLines: 100)
        VStack {
            HStack {

                VStack {
                    Text("Source data")
                        .font(.title)
                    List {
                        ForEach(datesToConvert) { entry in
                            Text(entry.value)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DateConvertView()
}
