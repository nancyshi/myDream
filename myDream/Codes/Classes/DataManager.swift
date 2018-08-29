//
//  DataManager.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/29.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation
import CoreData
enum DataForReportType {
    case winGame
    case loseGame
    case changeDollor
    case changeReputation
}
enum ReasonForChangeDollor {
    case winGame
    case decideStake
    case getTaskReward
    case purchaseHouse
}
enum ReasonForChangeReputation {
    case winGame
    case loseGame
    case getTaskReward
}
class DataManager {
    static let shared = DataManager()
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: "dataModel")
        container.loadPersistentStores(completionHandler: {(des,err) in
            if let erro = err {
                fatalError("fail to load persistent store")
            }
        })
        return container
    }()
    var houseConfig: [House]?
    var functionaryConfig: [Functionary]?
    var currentReportedData : DataForReport? {
        didSet(old) {
            guard currentReportedData != nil else {
                return
            }
            if observers.count != 0 {
                for oneObserver in observers {
                    oneObserver.didReciveReport(report: currentReportedData!)
                }
            }
        }
    }
    var observers: [TaskObserver] = [TaskObserver]()
    init() {
        houseConfig = self.loadJsonData(fileName: "houseConfig", givenType: [House].self)
        functionaryConfig = self.loadJsonData(fileName: "functionaryConfig", givenType: [Functionary].self)
    }
    func loadJsonData<TP:Codable>(fileName:String,givenType:TP.Type) -> TP? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("can't find file named \(fileName)")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let jsonData = try? Data.init(contentsOf: url) else{
            print("something wrong in reading file data")
            return nil
        }
        let decoder = JSONDecoder()
        
        guard let results = try? decoder.decode(givenType, from: jsonData) else {
            return nil
        }
        return results
    }
    
    func saveData() {
        do{
           try self.persistentContainer.viewContext.save()
        }
        catch {
            print("something is wrong with save data,info: \(error)")
        }
    }
    func getPlayerData() -> PlayerData? {
        let fetchRequest = NSFetchRequest<PlayerData>(entityName: "PlayerData")
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            print("something wrong with get playerData")
            return nil
        }
        if result.count == 0 {
            let initPlayerData = NSEntityDescription.insertNewObject(forEntityName: "PlayerData", into: persistentContainer.viewContext)
            initPlayerData.setValue(100, forKey: "currentDollor")
            self.saveData()
            return initPlayerData as? PlayerData
        }
        return result[0]
        
    }
    func getFunctionaryById(id givenId:Int) -> Functionary? {
        guard functionaryConfig != nil else {
            return nil
        }
        for oneFunctionary in functionaryConfig! {
            if oneFunctionary.id == givenId {
                
                return oneFunctionary
            }
        }
        return nil
    }
}

struct DataForReport {
    var type : DataForReportType
    var para : Any?
}



