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
    func getPointAndAnotherPoint() -> (thePoint:Int,theAnotherPoint:Int?) {
        guard self.cards.count > 0 else {
            print("cards of player is empty")
            return (0,nil)
        }
        var pointResult = 0
        var isAinCards = false
        for oneCard in self.cards {
            pointResult += oneCard.value
            if oneCard.value == 1 {
                isAinCards = true
            }
        }
        var anotherPointResult = isAinCards ? pointResult + 10 : nil
        if anotherPointResult != nil {
            if anotherPointResult! > 21 {
                anotherPointResult = nil
            }
        }
        return (pointResult,anotherPointResult)
    }
    func updatePointValues() {
        self.Point = self.getPointAndAnotherPoint().thePoint
        self.anotherPoint = self.getPointAndAnotherPoint().theAnotherPoint
    }
    func setUpPointLabel() {
        self.pointLabel.position = self.isFunctionary == true ? CGPoint(x: -1.362, y: -24.75) : CGPoint(x: -1.362, y: -114.75)
        self.pointLabel.text = self.anotherPoint == nil ? String(self.Point) : String(self.Point) + "/" + String(self.anotherPoint!)
        if self.anotherPoint == 21 {
            self.pointLabel.text = "21"
        }
    }
}
