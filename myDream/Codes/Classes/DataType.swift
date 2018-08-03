//
//  DataType.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/29.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation
import CoreData
struct Functionary : Codable {
    var imageName: String
    var id: Int
    var name: String
    var headIconName: String
}

struct House : Codable {
    var id: Int
    var name: String
    var maxStake: Int
    var minStake: Int
    var dollorForPurchase: Int
    var functionaryId: Int
    var minReputationForPurchase: Int
    var sortOrder:Int
    
    func getSQLDataById(id givenId:Int) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<HouseData>.init(entityName: "HouseData")
        let predicate = NSPredicate.init(format: "id == %d", self.id)
        fetchRequest.predicate = predicate
        guard let result = try? DataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else {
            return nil
        }
        if result.count == 0{
            return nil
        }
        else {
            return result[0]
        }
    }
}
