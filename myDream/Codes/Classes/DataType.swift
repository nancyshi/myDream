//
//  DataType.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/29.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import Foundation

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
    var originDollor: Int
    var functionaryId: Int
}
