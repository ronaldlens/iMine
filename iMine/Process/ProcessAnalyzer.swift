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
    var timeEnd: Date?
    var duration: DateInterval
    var startingVertices: [ProcessVertex]
    var endingVertices: [ProcessVertex]
    
    init(name: String, isStart: Bool, timeStart: Date, timeEnd: Date?) {
        self.name = name
        self.isStart = isStart
        self.isend =  !isStart
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        if timeEnd != nil {
            self.duration = DateInterval(start: timeStart, end: timeEnd!)
        } else {
            self.duration = DateInterval()
        }
        startingVertices = []
        endingVertices = []
    }
}

class Process {
    let correlation: String
    var steps: [ProcessStep] = []
    var vertices: [ProcessVertex] = []
    var count: Int {
        return steps.count
    }
    
    init(correlation: String) {
        self.correlation = correlation
    }
}

struct ProcessOutline: Identifiable {
    let id = UUID()
    var name: String
    var image: String
    var children: [ProcessOutline]?
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
            if configuration.timeEndColumnName != "None" {
                timeEnd = nil
            } else {
                timeEnd = (row[configuration.timeEndColumnName] as! Date)
            }
            let isStart = processIsNew
            let step =  ProcessStep(name: name, isStart: isStart, timeStart: timeStart, timeEnd: timeEnd)
            process.steps.append(step)
            
            if (processIsNew) {
                processes[correlation] = process
            }
        }
        print("Found \(processes.count) processes")
        
        processes.enumerated().forEach { (idx, process) in
            print("Process \(idx) with \(process.value.count) steps")
            if idx == 99 {
                process.value.steps.enumerated().forEach { (idx1, step) in
                    print("step \(idx1): \(step.name) \(step.timeStart) \(step.duration)")
                    
                }
            }
        
        }
    }
}
