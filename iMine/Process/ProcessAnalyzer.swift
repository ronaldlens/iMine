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

class ProcessStep {
    let name: String
    var isStart: Bool
    var isend: Bool
    var timeStart: Date
    var timeEnd: Date?
    var duration: TimeInterval
    var actor: String
    
    init(name: String, isStart: Bool, timeStart: Date, timeEnd: Date?, actor: String) {
        self.name = name
        self.isStart = isStart
        self.isend =  !isStart
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.duration = TimeInterval()
        self.actor = actor
    }
}

struct StepCount: Identifiable {
    var id = UUID()
    var name: String
    var count: Int
    var countString : String {
        return "\(count)"
    }
}

struct StepDetails: Identifiable {
    var id = UUID()
    var name: String
    var duration: TimeInterval
    var durationString: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
    var actor: String
    
}

class Process {
    let correlation: String
    var steps: [ProcessStep] = []
    var count: Int {
        return steps.count
    }
    
    init(correlation: String) {
        self.correlation = correlation
    }
    
    func analyzeStepCounts() -> [StepCount] {
        if count == 0 {
            return []
        }
        
        var result: [StepCount] = []
        for step in steps {
            if let idx = result.firstIndex(where: { $0.name == step.name }) {
                result[idx].count += 1
            } else {
                result.append(StepCount(name: step.name, count: 1))
            }
        }
        result.sort {
            $0.count > $1.count
        }
        return result
    }
    
    func analyzeSteps() -> [StepDetails] {
        if count == 0 {
            return []
        }
        
        var result: [StepDetails] = []
        for step in steps {
            result.append(StepDetails(name: step.name, duration: step.duration, actor: step.actor))
        }
        return result
    }
}

enum ProcessOutlineItemType {
    case process
    case step
}

struct ProcessOutlineItem: Identifiable, Equatable {
    static func == (lhs: ProcessOutlineItem, rhs: ProcessOutlineItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var name: String
    var image: String
    var children: [ProcessOutlineItem]?
    var process: Process?
    var processStep: ProcessStep?
    var type: ProcessOutlineItemType {
        if process == nil {
            return .step
        } else {
            return .process
        }
    }
}

@Observable class ProcessOutline {
    var items: [ProcessOutlineItem]
    
    init() {
        items = []
    }
    
    func findItemById(id: UUID) -> ProcessOutlineItem? {
        for item in items {
            if item.id == id {
                return item
            }
            if let subItems = item.children {
                for subItem in subItems {
                    if subItem.id == id {
                        return subItem
                    }
                }
            }
        }
        return nil
    }
        
}


class Analyzer {
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



