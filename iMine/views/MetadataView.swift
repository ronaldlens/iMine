//
//  MetadataView.swift
//  iMine
//
//  Created by Ronald Lens on 10/09/2023.
//

import SwiftUI

struct MetadataView: View {
    @State var columnSelection: ColumnMetadata.ID? = nil
    @State private var isTypeConverting = false
    @State private var isRenaming = false
    @State private var isDropping = false
    @State var columnToChange: ColumnMetadata? = nil
    @State var newColumnName = ""
    @State var columnName = ""
    
    let dfData = DfData.shared
    
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
                            Button("Convert to Date Type") {
                                columnToChange = column
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
    
    func typeConvertColumn() {
        print("typeconvert")
    }
    
    func renameColumn() {
        guard let columnToChange = columnToChange else { return }
        dfData.renameColumn(from: columnToChange.name, to: newColumnName)
        DfData.shared.updateMetadataFromDf()
    }
    
    func dropColumn() {
        dfData.dropColumn(name: columnName)
        DfData.shared.updateMetadataFromDf()
    }
   

}
#Preview {
    MetadataView()
}

