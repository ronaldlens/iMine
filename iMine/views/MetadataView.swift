//
//  MetadataView.swift
//  iMine
//
//  Created by Ronald Lens on 10/09/2023.
//

import SwiftUI

struct MetadataView: View {
    @Environment(CenterViewState.self) private var centerViewState
    @Environment(DfData.self) private var dfData
    
    @State var columnSelection: ColumnMetadata.ID? = nil
    @State private var isNilDropping = false
    @State private var isTypeConverting = false
    @State private var isRenaming = false
    @State private var isDropping = false
    @State var columnToChange: ColumnMetadata? = nil
    @State var newColumnName = ""
    @State var columnName = ""
    
    var body: some View {
        VStack {
            Text("Loaded data metadata")
                .font(.title)
                .multilineTextAlignment(.center)
            
            Table(of: ColumnMetadata.self, selection: $columnSelection) {
                TableColumn("Name", value: \.name)
                TableColumn("Type", value: \.wrappedType)
                TableColumn("Count") { col in
                    Text("\(col.totalCount)")
                }
                TableColumn("Missing") { col in
                    Text("\(col.missingCount)")
                }
            } rows: {
                ForEach(dfData.columnMetadata) { column in
                    TableRow(column)
                        .contextMenu {
                            Button("Drop nil rows") {
                                columnName = column.name
                                isNilDropping.toggle()
                            }
                            Button("Convert to Date Type") {
                                centerViewState.selectedColumn = column.name
                                isTypeConverting.toggle()
                            }
                            Divider()
                            Button("Rename column") {
                                columnToChange = column
                                newColumnName = column.name
                                isRenaming.toggle()
                            }
                            Button("Drop column", role: .destructive) {
                                columnName = column.name
                                isDropping.toggle()
                            }
                        }
                    
                    
                }
            }
            .alert("Drop rows with nil", isPresented: $isNilDropping) {
                Button("OK", action: dropNilInColumn)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Do you really want to drop rows with a nil value in [\(columnName)]")
            }
            .dialogIcon(Image(systemName: "xmark.circle"))
            .sheet(isPresented: $isTypeConverting) {
            } content: {
                DateConvertSheet()
                    .frame(width: 640, height: 480)
            }
            .alert("Rename column", isPresented: $isRenaming) {
                TextField("New column name", text: $newColumnName)
                Button("OK", action: renameColumn)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Rename column")
            }
            .dialogIcon(Image(systemName: "slider.horizontal.below.square.filled.and.square"))
            .alert("Drop \(columnName)", isPresented: $isDropping) {
                Button("OK", action: dropColumn)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Do you really want to drop this column, this cannot be undone")
            }
            .dialogIcon(Image(systemName: "delete.left"))
            
        }
    }
    
    func dropNilInColumn() {
        dfData.dropRowsWithNilInColumn(name: columnName)
    }
    
    func renameColumn() {
        guard let columnToChange = columnToChange else { return }
        dfData.renameColumn(from: columnToChange.name, to: newColumnName)
    }
    
    func dropColumn() {
        dfData.dropColumn(name: columnName)
    }
   

}
#Preview {
    MetadataView()
        .environment(DfData())
        .environment(CenterViewState())
}


