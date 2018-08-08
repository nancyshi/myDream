//
//  PlayerOfBlackJack.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/8.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerOfBlackJack: SKNode {
    var Point : Int = 0
    var anotherPoint : Int?
    var cards : [Card] = [Card]()
    var pointLabel : SKLabelNode
    var isFunctionary : Bool = false
    
    override init() {
        pointLabel = SKLabelNode(text: "default")
        pointLabel.fontName = "PingFang SC Semibold"
        pointLabel.fontSize = 20
        pointLabel.fontColor = UIColor.white
        super.init()
    }
    
    convenience init(isFunctionary givenValue:Bool) {
        self.init()
        isFunctionary = givenValue ? true : false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func distributeCardsHorizontally(originPoint givenPoint: CGPoint, gap givenGap:Float) -> [CGPoint] {
        var result = [CGPoint]()
        guard self.cards.count > 0 else {
            return result
        }
        let wholeLengthOfCards = Float((cards.count - 1)) * givenGap + Float(cards[0].frame.size.width)
        let leftSideX = Float(givenPoint.x) - wholeLengthOfCards / 2
        for index in 0 ... cards.count - 1 {
            let x = CGFloat(leftSideX + Float(index) * givenGap + Float(cards[index].frame.size.width/2))
            let y = givenPoint.y
            result.append(CGPoint(x: x, y: y))
            cards[index].zPosition = CGFloat(index)
        }
        return result
    }
}
