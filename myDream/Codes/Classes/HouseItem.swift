//
//  houseItem.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/22.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class HouseItem: SKButton {
    var houseNameLabel = SKLabelNode(text: "Coming House")
    var headIconNode = SKSpriteNode()
    var minLabel = SKLabelNode(text: "$ 20")
    var maxLabel = SKLabelNode(text: "$ 200K")
    var house: House?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        if let prefab = SKReferenceNode(fileNamed: "houseItem") {
            let backGround = prefab.children[0].children[0]
            backGround.removeFromParent()
            self.addChild(backGround)
            self.size = backGround.frame.size
            
            minLabel = backGround.childNode(withName: "//minLabel") as! SKLabelNode
            maxLabel = backGround.childNode(withName: "//maxLabel") as! SKLabelNode
            headIconNode = backGround.childNode(withName: "//headIcon") as! SKSpriteNode
            houseNameLabel = backGround.childNode(withName: "//houseNameLabel") as! SKLabelNode
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
    }
}
