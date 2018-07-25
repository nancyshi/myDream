//
//  SKScrollNode.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/24.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class SKScrollNode: SKCropNode {
    var container:SKScrollNodeContainer = SKScrollNodeContainer()
    var contentSize : CGSize {
        get {
            return container.size
        }
        set {
            if let maskNode = maskNode {
                if contentSize.height > maskNode.frame.size.height && maskNode.frame.size.height > 0 {
                    container.isUserInteractionEnabled = true
                }
                else {
                    container.isUserInteractionEnabled = false
                }
            }
        }
    }
    var maskNodeSize:CGSize? {
        get {
            return maskNode?.frame.size
        }
        set {
            if let maskNode = maskNode {
                if contentSize.height > maskNode.frame.size.height && maskNode.frame.size.height * maskNode.frame.size.width > 0 {
                    container.isUserInteractionEnabled = true
                    container.minTopY = maskNode.frame.size.height/2 + maskNode.position.y
                    container.maxBottomY = maskNode.position.y - maskNode.frame.size.height/2
                }
                else {
                    container.isUserInteractionEnabled = false
                }
            }
        }
    }

    override init() {
        super.init()
        self.addChild(container)
        container.color = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setContainerTopOrBottom(top:Bool) {
        if let maskNode = maskNode {
            if maskNode.frame.size.height > 0 && maskNode.frame.size.width > 0 {
                if top == true {
                    let topY = maskNode.position.y + maskNode.frame.size.height/2
                    container.position.y = topY - container.size.height/2
                }
                else {
                    let bottomY = maskNode.position.y - maskNode.frame.size.height/2
                    container.position.y = bottomY + maskNode.frame.size.height/2
                }
            }
            else {
                print("this scroll node's mask node doesn't appera on the screen")
            }
        }
        else {
            print("this scroll node has no maskNode")
        }
    }
    func refreshPropoties() {
        container.topY = container.size.height/2 + container.position.y
        container.bottomY = container.position.y - container.size.height/2
        maskNodeSize = maskNode?.frame.size
        contentSize = container.size
        
    }
    
    
}


enum SKScrollNodeContainerRangeTestCase {
    case inRange
    case minTopYErro
    case maxBottomYErro
}
class SKScrollNodeContainer: SKSpriteNode {
    
    var minTopY : CGFloat = 0
    var maxBottomY : CGFloat = 0
    var topY : CGFloat{
        get {
            return self.size.height/2 + self.position.y
        }
        set {
            
        }
    }
    var bottomY : CGFloat {
        get {
            return self.position.y - self.size.height/2
        }
        set {
            
        }
    }
    
//    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.isUserInteractionEnabled = true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //scroll behavior
        if isPositionInRange(aPosition: self.position) == .inRange {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self.parent!)    //never init a container alone , init it by a scrollNode
                let preLocation = touch.previousLocation(in: self.parent!)
                let dy = touchLocation.y - preLocation.y
                
                let willPositionY = self.position.y + dy
                if isPositionInRange(aPosition: CGPoint(x: 0, y: willPositionY)) == .inRange {
                    self.position.y = willPositionY
                }
                else if isPositionInRange(aPosition: CGPoint(x: 0, y: willPositionY)) == .minTopYErro {
                    self.position.y = minTopY - self.size.height/2
                }
                else {
                    self.position.y = maxBottomY + self.size.height/2
                }
            }
        }
        else {
            print("container fram is out of scrollable range")
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    private func isPositionInRange(aPosition:CGPoint) ->SKScrollNodeContainerRangeTestCase {
        
        let top = aPosition.y + self.size.height/2
        let bottom = aPosition.y - self.size.height/2
        if (top > minTopY || abs(top - minTopY) <= 0.01) && (bottom < maxBottomY || abs(bottom - maxBottomY) <= 0.01) {
            return .inRange
        }
        else if top < minTopY {
            return .minTopYErro
        }
        else  {
            return .maxBottomYErro
        }
    }
}
