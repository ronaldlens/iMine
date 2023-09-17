//
//  DateConvertDialog.swift
//  iMine
//
//  Created by Ronald Lens on 11/09/2023.
//

import SwiftUI

struct DateConvertSheet: View {
    @Environment(CenterViewState.self) private var centerViewState
    @Environment(DfData.self) private var dfData
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var convertString: String  = ""

    var body: some View {
        let columnName = centerViewState.selectedColumn
        let datesToConvert = dfData.getListFromColumn(name: columnName, noLines: 100)
        let convertedDates = tryConvertDates(src: datesToConvert, format: convertString)
        VStack {
            Text("Convert **\(columnName)** to Date")
                .font(.title2)
            HStack {
                TextField("Enter conversion mask", text: $convertString)
            }
            .padding()
            HStack {

                VStack {
                    List {
                        ForEach(datesToConvert) { entry in
                            Text(entry.value)
                        }
                    }
                    .padding()
                }
                VStack {
                    List {
                        ForEach(convertedDates) { entry in
                            Text(entry.value)
                        }
                    }
                }
            }
    
            HStack {
                Spacer()
                Button {
                    centerViewState.whatView = .metadata
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Button {
                    dfData.convertColumnStringToDate(name: columnName, format: convertString)
                    dfData.updateMetadataFromDf()
                    dismiss()
                } label: {
                    Text("Apply transform")
                }
            }
            .padding()
        }
    }
    
    func tryConvertDates(src: [StringEntry], format: String) -> [StringEntry] {
        print(format)
        let fromFormat = DateFormatter()
        fromFormat.dateFormat = format
        let toFormat = DateFormatter()
        toFormat.dateFormat = "HH:mm, d MMM y"
        
        var dateList: [StringEntry] = []
        for srcDate in src {
            let date = fromFormat.date(from: srcDate.value)
            if let date = date {
                let dateStr = StringEntry(value: toFormat.string(from: date))
                dateList.append(dateStr)
            } else {
                dateList.append(StringEntry(value: "Parse error"))
            }
        }
        return dateList
    }
}

#Preview {
    DateConvertSheet()
}
