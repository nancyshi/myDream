//
//  SKScrollNode.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/22.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class SKScrollNode: SKCropNode {
    var container = SKScrollNodeContainer(texture: nil, color: UIColor.red, size: CGSize(width: 100, height: 100))
    
    override init() {
        super.init()
        self.addChild(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addChild(container)
    }
}


class SKScrollNodeContainer: SKSpriteNode {
    var isTouchSolvedBySelf : Bool = true
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    func isTouchInsideOfMaskNode(touch:UITouch) -> Bool? {
        if let p = self.parent as? SKScrollNode {
            if let maskNode = p.maskNode {
                let touchLocation = touch.location(in: p)
                if maskNode.contains(touchLocation) {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                print("there is no maskNode")
                return nil
            }
        }
        else {
            print("there is no parent of the container")
            return nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {
            if self.isTouchInsideOfMaskNode(touch: touch) == true {
                self.isTouchSolvedBySelf = true
                
            }
            else if self.isTouchInsideOfMaskNode(touch: touch) == false {
                self.isTouchSolvedBySelf = false
                if let p = self.parent as? SKScrollNode {
                    let touchLocation = touch.location(in: p.parent!)
                    let nodes = p.parent!.nodes(at: touchLocation)
                    for oneNode in nodes {
                        if oneNode != self {
                            if oneNode.isUserInteractionEnabled == true {
                                oneNode.touchesBegan(touches, with: event)
                                break
                            }
                        }
                    }
                }
            }
            else {
                //there is something wrong
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isTouchSolvedBySelf == true {
                    if let p = self.parent as? SKScrollNode {
                        if let maskNode = p.maskNode {
                            let minTopY = maskNode.position.y + maskNode.frame.size.height/2
                            let maxBottomY = maskNode.position.y - maskNode.frame.size.height/2
            
                            let topY = self.position.y + self.size.height/2
                            let bottomY = self.position.y - self.size.height/2
            
                            if topY >= minTopY || bottomY <= maxBottomY {
                                if let touch = touches.first {
                                    let touchLocation = touch.location(in: self.parent!)
                                    let preLocation = touch.previousLocation(in: self.parent!)
                                    let dy = touchLocation.y - preLocation.y
            
                                    let willTopY = self.position.y + dy + self.size.height/2
                                    let willBottomY = self.position.y + dy - self.size.height/2
            
                                    if willTopY >= minTopY && willBottomY <= maxBottomY {
                                        self.position.y = self.position.y + dy
                                        //self.run(SKAction.move(by: CGVector.init(dx: 0, dy: dy), duration: touch.timestamp))
                                    }
                                    else {
                                        if willTopY < minTopY {
                                            self.position.y = minTopY - self.size.height/2
                                        }
                                        if willBottomY > maxBottomY {
                                            self.position.y = maxBottomY + self.size.height/2
                                        }
                                    }
                                }
                            }
                        }
                    }
        }
        else if self.isTouchSolvedBySelf == false {
            if let touch = touches.first {
                self.isTouchSolvedBySelf = false
                if let p = self.parent as? SKScrollNode {
                    let touchLocation = touch.location(in: p.parent!)
                    let nodes = p.parent!.nodes(at: touchLocation)
                    for oneNode in nodes {
                        if oneNode != self {
                            if oneNode.isUserInteractionEnabled == true {
                                oneNode.touchesMoved(touches, with: event)
                                break
                            }
                        }
                    }
                }
            }
        }
        else {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchSolvedBySelf == true {
            
        }
        else if self.isTouchSolvedBySelf == false {
            if let touch = touches.first {
                self.isTouchSolvedBySelf = false
                if let p = self.parent as? SKScrollNode {
                    let touchLocation = touch.location(in: p.parent!)
                    let nodes = p.parent!.nodes(at: touchLocation)
                    for oneNode in nodes {
                        if oneNode != self {
                            if oneNode.isUserInteractionEnabled == true {
                                oneNode.touchesEnded(touches, with: event)
                                break
                            }
                        }
                    }
                }
            }
            self.isTouchSolvedBySelf = true
        }
    }
}
