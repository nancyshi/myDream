//
//  Task.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/21.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation
import SpriteKit
enum TaskState {
    case defaultState
    case accept
    case complete
    case gotReward
}
class Task {
    var name : String? = nil
    var description : String = "default"
    var strForProgressReport : String? {
        didSet(old) {
            guard self.labelForShow != nil else {
                return
            }
            self.labelForShow!.text = self.description + self.strForProgressReport!
        }
    }
    var state : TaskState = .defaultState {
        didSet(old) {
            if state == .complete {
                print("task complete")
            }
        }
    }
    var condition : TaskCondition = TaskCondition(){
        didSet(old) {
            condition.task = self
        }
    }
    var observer : TaskObserver = TaskObserver(){
        didSet(old) {
            observer.condition = self.condition
        }
    }
    var labelForShow : SKLabelNode?
    func updateStrForProgressReport() {
        //for subclasses to override
    }
    
    
    static func winGameType(name givenName:String? ,desc givenDesc:String,isNeedProgressReport givenNeedReport : Bool, winTime givenWinTime:Int , isNeedContinued givenNeedContinued : Bool) -> TaskWinGame {
        let result = TaskWinGame()
        result.name = givenName
        result.description = givenDesc
        
        result.condition = TaskCondition.winGame(time: givenWinTime, isRequiredContinue: givenNeedContinued)
        result.observer = TaskObserver.winGame()
        
        if givenNeedReport == true {
            result.updateStrForProgressReport()
        }
        return result
    }
}
class TaskWinGame : Task {
    override func updateStrForProgressReport() {
        let currentNum = (self.observer as! TaskObserverWinGame).currentWinNum
        let willNum = (self.condition as! TaskConditionWinGame).winTime
        let str = "(\(currentNum)/\(willNum))"
        self.strForProgressReport = str
    }
}
class TaskCondition {
    //it's just an abstract class for different subclasses with compeletly different vars
    var task : Task? = nil
    class func winGame(time givenTime: Int, isRequiredContinue givenIsRequiredContinue:Bool) -> TaskCondition{
        let result = TaskConditionWinGame.init()
        result.winTime = givenTime
        result.isRequiredContinue = givenIsRequiredContinue
        return result
    }
}
class TaskConditionWinGame: TaskCondition {
    var isRequiredContinue : Bool = false
    var winTime : Int = 0
}

class TaskObserver {
    // it's an abstract class for other observers
    var condition : TaskCondition = TaskCondition()
    var reportTypeForObserve : [DataForReportType] = [DataForReportType]()
    func didReciveReport(report givenReport : DataForReport) {
        //for subclasses to override
    }
    class func winGame() -> TaskObserver {
        let result = TaskObserverWinGame()
        return result
    }
}

class TaskObserverWinGame : TaskObserver {
    var currentWinNum = 0
    override init() {
        super.init()
        self.condition = TaskConditionWinGame()
        self.reportTypeForObserve = [.winGame,.loseGame]
    }
    override func didReciveReport(report givenReport: DataForReport) {
        guard self.reportTypeForObserve.contains(givenReport.type) else {
            return
        }
        if givenReport.type == .winGame {
            currentWinNum = currentWinNum + 1
            checkResult()
            self.condition.task?.updateStrForProgressReport()
        }
        else if givenReport.type == .loseGame {
            if (self.condition as! TaskConditionWinGame).isRequiredContinue == true {
                self.currentWinNum = 0
            }
        }
        
    }
    func checkResult() {
        if self.currentWinNum == (self.condition as! TaskConditionWinGame).winTime {
            self.condition.task!.state = .complete
            return
        }
    }
}

