//
//  ProcessAnalyzer.swift
//  iMine
//
//  Created by Ronald Lens on 18/09/2023.
//

import Foundation
import TabularData

struct AnalyzerConfiguration {
    let timeStartColumnName: String
    let timeEndColumnName: String
    let correlationColumnName: String
    let activityColumnName: String
    let actorColumnName: String
    let valueColumnName: String
}


class EventAnalyzer {
    var dfData: DfData
    let configuration: AnalyzerConfiguration
    var processes: [String:Process] = [:]
    var outline: ProcessOutline
    
    init(dfData: DfData, configuration: AnalyzerConfiguration) {
        self.dfData = dfData
        self.configuration = configuration
        self.outline = ProcessOutline()
    }
    
    func iterateDataFrame() {

        guard let df = dfData.dataFrame else { return }
        dfData.sortDataFrame(onColumn: configuration.timeStartColumnName)
        for row in df.rows {
            var processIsNew = false
            let correlation = "\(String(describing: row[configuration.correlationColumnName]!))"
            var process: Process
            if processes.keys.contains(correlation) {
                process = processes[correlation]!
            } else {
                process = Process(correlation: correlation)
                processIsNew = true
            }
            let name = "\(String(describing: row[configuration.activityColumnName]!))"
            let timeStart = row[configuration.timeStartColumnName] as! Date
            var timeEnd: Date?
            if configuration.timeEndColumnName == "None" {
                timeEnd = nil
            } else {
                timeEnd = (row[configuration.timeEndColumnName] as! Date)
            }
            var actor: String = ""
            if configuration.actorColumnName != "None" {
                actor = row[configuration.actorColumnName] as! String
            } else {
                actor = "N/A"
            }
            let isStart = processIsNew
            let step =  ProcessStep(name: name, isStart: isStart, timeStart: timeStart, timeEnd: timeEnd, actor: actor)
            process.steps.append(step)
            
            if (processIsNew) {
                processes[correlation] = process
            }
        }
        print("Found \(processes.count) processes")
        
        outline.items = []
        processes.enumerated().forEach { (idx, process) in
            
            var processOutlineItem = ProcessOutlineItem(name: "\(idx)", image: "")
            processOutlineItem.children = []
            processOutlineItem.process = process.value
            
            process.value.steps.enumerated().forEach { (sidx, step) in
                let stepOutlineItem = ProcessOutlineItem(
                    name: "step \(sidx) \(step.name)", image: "")
                processOutlineItem.children?.append(stepOutlineItem)
                processOutlineItem.processStep = step
                
                if configuration.timeEndColumnName == "None" {
                    if sidx != process.value.steps.count - 1 {
                        step.timeEnd = process.value.steps[sidx + 1].timeStart
                    } else {
                        step.timeEnd = step.timeStart + 1
                    }
                }
                step.duration = step.timeEnd!.timeIntervalSinceReferenceDate - step.timeStart.timeIntervalSinceReferenceDate
                
            }
            processOutlineItem.name = "\(idx) - \(processOutlineItem.children!.count) steps"
            outline.items.append(processOutlineItem)
        
        }
    }
}



