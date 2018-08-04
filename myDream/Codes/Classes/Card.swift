//
//  Card.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/5.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class Card: SKNode {
    var value : Int = 0
    var cardNode: SKSpriteNode = SKSpriteNode()
    var otherValue: Int?
    
    private override init() {
        super.init()
        cardNode = SKSpriteNode.init(imageNamed: "c_A")
        self.addChild(cardNode)
    }
    
    convenience init(imageNamed givenName: String, value givenValue: Int) {
        self.init()
        cardNode.texture = SKTexture(imageNamed: givenName)
        value = givenValue
        if value == 1 {
            otherValue = 11 //just for A
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
