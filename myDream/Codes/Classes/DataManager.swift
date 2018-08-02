//
//  DataManager.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/29.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation
import CoreData
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
}



