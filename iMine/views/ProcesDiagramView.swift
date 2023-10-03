//
//  ProcesDiagramView.swift
//  iMine
//
//  Created by Ronald Lens on 26/09/2023.
//

import SwiftUI

struct ProcesDiagramView: View {
    @Environment(CenterViewState.self) private var centerViewState: CenterViewState
    
    
    var body: some View {
        TabView {
            
            ScrollView {
                ForEach(1..<6) { i in
                    ProcessVertexView(name: "activity \(i)")
                    
                    
                    if i != 5 {
                        Rectangle()
                            .frame(width: 1, height: 20)
                    }
                }
            }
            .tabItem {
                Text("Full process")
            }
            ScrollView {
                ForEach(1..<6) { i in
                    ProcessVertexView(name: "activity \(i)")
                    
                    
                    if i != 5 {
                        Rectangle()
                            .frame(width: 1, height: 20)
                    }
                }

            }
            .tabItem {
                Text("Selected process")
            }
            
        }
    }
}

#Preview {
    ProcesDiagramView()
}


struct ProcessVertexView: View {
    @State var name: String
    
    var body: some View {
        Text(name)
            .foregroundStyle(.white)
            .padding(5)
            .background(.blue)
            .padding(20)
            .clipShape(Capsule())
            .frame(minHeight: 20, maxHeight: 20)
    }
}

#Preview {
    ProcessVertexView(name: "Start activity")
}

