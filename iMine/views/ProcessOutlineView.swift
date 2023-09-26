//
//  ProcessOutlineView.swift
//  iMine
//
//  Created by Ronald Lens on 24/09/2023.
//

import SwiftUI

struct ProcessOutlineView: View {
    @Environment(CenterViewState.self) private var centerViewState: CenterViewState
    
    var body: some View {
        if let outlineItem = centerViewState.selectedOutlineItem {
            if outlineItem.type == .process {
                Text("\(outlineItem.name)")
                    .font(.title2)
                    .padding()
                let stepsCounts: [StepCount] = outlineItem.process!.analyzeStepCounts()
            
                TabView {
                    Table(stepsCounts) {
                        TableColumn("Name", value: \.name)
                        TableColumn("Count", value: \.countString)
                    }
                    .tabItem {
                        Text("Process steps count")
                    }
                    let stepDetails = outlineItem.process!.analyzeSteps()
                    
                    Table(stepDetails) {
                        TableColumn("Name", value: \.name)
                        TableColumn("Actor", value: \.actor)
                        TableColumn("Duration", value: \.durationString)
                                    
                        
                    }
                    .tabItem {
                        Text("Process steps")
                        
                    }
                    
                }
            } else {
                Text("Step \(outlineItem.name)")
                    .font(.title2)
            }
            
        } else {
            Text("No step selected")
                
        }
    }
}

#Preview {
    ProcessOutlineView()
}
