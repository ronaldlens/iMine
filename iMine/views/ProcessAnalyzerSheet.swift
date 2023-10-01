//
//  ProcessAnalyzerSheet.swift
//  iMine
//
//  Created by Ronald Lens on 19/09/2023.
//

import SwiftUI

struct ProcessAnalyzerSheet: View {
    @Environment(DfData.self) private var dfData
    @Environment(CenterViewState.self) private var centerViewState
    @Environment(ProcessOutline.self) private var processOutline
    @Environment(\.dismiss) private var dismiss
    
    @State private var correlationSel: String = "None"
    @State private var startTimeSel: String = "None"
    @State private var endTimeSel: String = "None"
    @State private var activitySel: String = "None"
    @State private var actorSel: String = "None"
    @State var columnList: [String] = []
    @State private var missingColumn: String = ""
    @State private var showMissingColumn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State var okToAnalyze = true
    
    var body: some View {
        let columnList = getColumnNames(dfData: dfData)
        VStack(alignment: .leading) {
            
            
            Text("Set columns for analysis of processes")
                .font(.title)
            Section() {
                ColumnPicker(pickerName: "Correlation", columnList: columnList, selection: $correlationSel)
                ColumnPicker(pickerName: "Start time", columnList: columnList, selection: $startTimeSel)
                ColumnPicker(pickerName: "End time", columnList: columnList, selection: $endTimeSel)
                ColumnPicker(pickerName: "Activity", columnList: columnList, selection: $activitySel)
                ColumnPicker(pickerName: "Actor", columnList: columnList, selection: $actorSel)
            }
        }
        .padding()
        
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
            Button {
                okToAnalyze = true
                let analyzerConfiguration = AnalyzerConfiguration(
                    timeStartColumnName: $startTimeSel.wrappedValue,
                    timeEndColumnName: $endTimeSel.wrappedValue,
                    correlationColumnName: $correlationSel.wrappedValue,
                    activityColumnName: $activitySel.wrappedValue,
                    actorColumnName: $actorSel.wrappedValue,
                    valueColumnName: "None")
                if analyzerConfiguration.activityColumnName == "None" {
                    missingColumn = "Activity"
                    showMissingColumn.toggle()
                    okToAnalyze = false
                }
                if analyzerConfiguration.correlationColumnName == "None" {
                    missingColumn = "Correlation"
                    showMissingColumn.toggle()
                    okToAnalyze = false
                }
                if let column = dfData.getMetadata(columnName: analyzerConfiguration.timeStartColumnName) {
                    if column.wrappedType != "Date" {
                        errorMessage = "TimeStart column has to be of type Date"
                        okToAnalyze = false
                        showError.toggle()
                    }
                        
                    
                }
                if okToAnalyze {
                    dismiss()
                    let analyser = EventAnalyzer(dfData: dfData, configuration: analyzerConfiguration)
                    analyser.iterateDataFrame()
                    let outline = analyser.outline
                    processOutline.items = outline.items
                    centerViewState.processes = analyser.processes
                    centerViewState.whatView = .processOutline
                    
                }
            } label: {
                Text("Apply selection")
            }
            .alert(
                "Missing column selection",
                isPresented: $showMissingColumn) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text("Cannot analyze without \(missingColumn) column")
                }
                .alert(
                    "Error setting columns for analysis",
                    isPresented: $showError) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text("Cannot analyze due to\n \(errorMessage) column")
                    }
            

        }
        .padding()
    }
    
    func checkConfiguration() {
        
    }
}

func getColumnNames(dfData: DfData) -> [String] {
    var columnList: [String] = []
    for col in dfData.columnMetadata {
        columnList.append(col.name)
    }
    columnList.append("None")
    return columnList
}

//#Preview {
//    ProcessAnalyzerSheet(columnList: [])
//        .environment(DfData())
//}

struct ColumnPicker: View {
    var pickerName: String
    var columnList: [String]
    @Binding var selection: String
    
    var body: some View {
        HStack {
            Text("\(pickerName):")
                .frame(width: 100, alignment: .trailing)
            Picker(pickerName, selection: $selection) {
                ForEach(columnList, id: \.self) { column in
                    Text(column).tag(column)
                }
                
                
            }
            .labelsHidden()
            .frame(alignment: .leading)
            .padding(.leading)
            .padding(.trailing)
        }
    }
}
