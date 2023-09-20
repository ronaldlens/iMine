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
    let correlationColumnName: String
    let activityColumnName: String
    let actorColumnName: String
    let valueColumnName: String
}

class ProcessVertex {
    let from: ProcessStep
    let to: ProcessStep
    
    init(from: ProcessStep, to: ProcessStep) {
        self.from = from
        self.to = to
    }
}

class ProcessStep {
    let name: String
    var isStart: Bool
    var isend: Bool
    var timeStart: Date
    var startingVertices: [ProcessVertex]
    var endingVertices: [ProcessVertex]
    
    init(name: String, isStart: Bool, timeStart: Date) {
        self.name = name
        self.isStart = isStart
        self.isend =  !isStart
        self.timeStart = timeStart
        startingVertices = []
        endingVertices = []
    }
}

class Process {
    let correlation: String
    var steps: [ProcessStep] = []
    var vertices: [ProcessVertex] = []
    var length: Int {
        return steps.count
    }
    
    init(correlation: String) {
        self.correlation = correlation
    }
}

class Analyzer {
    var dfData: DfData
    let configuration: AnalyzerConfiguration
    var processes: [String:Process] = [:]
    
    init(dfData: DfData, configuration: AnalyzerConfiguration) {
        self.dfData = dfData
        self.configuration = configuration
    }
    
    func iterateDataFrame() {
        var process: Process
        
        guard let df = dfData.dataFrame else { return }
        dfData.sortDataFrame(onColumn: configuration.timeStartColumnName)
        for row in df.rows {
            var processIsNew = false
            let correlation = "\(String(describing: row[configuration.correlationColumnName]!))"
            if processes.keys.contains(correlation) {
                process = processes[correlation]!
            } else {
                process = Process(correlation: correlation)
                processIsNew = true
            }
            let name = "\(String(describing: row[configuration.activityColumnName]!))"
            let timeStart = row[configuration.timeStartColumnName] as! Date
            let isStart = processIsNew
            let step =  ProcessStep(name: name, isStart: isStart, timeStart: timeStart)
            process.steps.append(step)
            
            if (processIsNew) {
                processes[correlation] = process
            }
        }
        print("Found \(processes.count) processes")
    }
}
