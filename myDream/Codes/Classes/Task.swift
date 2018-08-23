//
//  Task.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/21.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation
enum TaskState {
    case defaultState
    case accept
    case complete
    case gotReward
}
class Task {
    var name : String?
    var description : String = "default"
    var state : TaskState = .defaultState
    var condition : TaskCondition = TaskCondition()
}
class TaskCondition {
    //it's just an abstract class for different subclasses with compeletly different vars
    
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

