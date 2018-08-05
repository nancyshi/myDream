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
    var cardBackTextureBlue = SKTexture(imageNamed: "back_blue")
    var cardBackTextureRed = SKTexture(imageNamed: "back_red")
    var originTexture: SKTexture?
    var otherValue: Int?
    
    private override init() {
        super.init()
        cardNode = SKSpriteNode.init(imageNamed: "c_A")
        originTexture = cardNode.texture
        self.addChild(cardNode)
    }
    
    convenience init(imageNamed givenName: String, value givenValue: Int) {
        self.init()
        cardNode.texture = SKTexture(imageNamed: givenName)
        originTexture = cardNode.texture
        value = givenValue
        if value == 1 {
            otherValue = 11 //just for A
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func getWholeCards() -> [Card] {
        var dic = [String:Int]()
        for pre in ["c","d","h","s"] {
            for index in 2...10 {
                let key = pre + "_" + String(index)
                dic[key] = index
            }
            dic[pre + "A"] = 1
            dic[pre + "J"] = 10
            dic[pre + "Q"] = 10
            dic[pre + "K"] = 10
        }
        var result = [Card]()
        for (key,value) in dic {
            let oneCard = Card(imageNamed: key, value: value)
            result.append(oneCard)
        }
        return result
    }
    class func getWholeCards(multiper multi: Int) -> [Card] {
        var result = [Card]()
        guard multi >= 1 else {
            print("multiper must bigger than 1")
            return result
        }
        for _ in 1...multi {
            let resultTemp = self.getWholeCards()
            result = result + resultTemp
        }
        return result
    }
}
