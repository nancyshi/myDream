//
//  houseItem.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/22.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit
enum HouseItemStatus {
    case enabled
    case disabled
    case canPurchased
    case purchased
}
class HouseItem: SKButton {
    var backGroundNode:SKSpriteNode = SKSpriteNode()
    var houseNameLabel = SKLabelNode(text: "Coming House")
    var headIconNode = SKSpriteNode()
    var minLabel = SKLabelNode(text: "$ 20")
    var maxLabel = SKLabelNode(text: "$ 200K")
    var itemStatus: HouseItemStatus = .disabled {
        didSet(old) {
            if itemStatus == .enabled {
                self.performEnabled()
            }
            else if itemStatus == .disabled {
                self.performDisabled()
            }
        }
    }
    var house: House?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        if let prefab = SKReferenceNode(fileNamed: "houseItem") {
            let backGround = prefab.children[0].children[0] as! SKSpriteNode
            backGround.removeFromParent()
            self.backGroundNode = backGround
            self.addChild(backGround)
            self.size = backGround.frame.size
            
            minLabel = backGround.childNode(withName: "//minLabel") as! SKLabelNode
            maxLabel = backGround.childNode(withName: "//maxLabel") as! SKLabelNode
            headIconNode = backGround.childNode(withName: "//headIcon") as! SKSpriteNode
            houseNameLabel = backGround.childNode(withName: "//houseNameLabel") as! SKLabelNode
            
            self.performDisabled()
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init() {
        self.init(texture: nil, color: UIColor.clear, size: CGSize(width: 100, height: 100))
    }
    convenience init(aHouse:House) {
        self.init(texture: nil, color: UIColor.clear, size: CGSize(width: 100, height: 100))
        self.house = aHouse
        self.houseNameLabel.text = aHouse.name
        self.minLabel.text = "$ " + String(aHouse.minStake)
        self.maxLabel.text = "$ " + String(aHouse.maxStake)
        
        if let sqlData = aHouse.getSQLDataById(id: aHouse.id) {
            if let statusNum = sqlData.value(forKey: "status") as? Int {
                switch statusNum {
                case 0:
                    break
                case 1:
                    self.itemStatus = .enabled
                    self.performEnabled()
                    break
                case 2:
                    self.itemStatus = .canPurchased
                    break
                case 3:
                    self.itemStatus = .purchased
                default:
                    print("something is wrong with exchange houe's sql status")
                    break
                }
            }
        }
    }
    
    func performDisabled() {
        self.isUserInteractionEnabled = false
        self.backGroundNode.texture = SKTexture(imageNamed: "houseItem_bg_disabled")
    }
    func performEnabled() {
        self.isUserInteractionEnabled = true
        self.backGroundNode.texture = SKTexture(imageNamed: "houseItem_bg")
    }
}
