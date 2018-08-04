//
//  NaviBar.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/4.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class NaviBar: SKSpriteNode {
    var backButton: SKButton?
    var dollorLabel: SKLabelNode?
    var reputationLabel: SKLabelNode?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        if let prefab = SKReferenceNode(fileNamed: "naviBar")?.children[0].children[0] as? SKSpriteNode {
            self.size = prefab.size
            self.texture = prefab.texture
            for oneNode in prefab.children {
                oneNode.removeFromParent()
                self.addChild(oneNode)
            }
            dollorLabel = self.childNode(withName: "//dollorLabel") as? SKLabelNode
            reputationLabel = self.childNode(withName: "//repuLabel") as? SKLabelNode
            backButton = self.childNode(withName: "//backButton") as? SKButton
            dollorLabel?.zPosition = 1
            reputationLabel?.zPosition = 1
            backButton?.zPosition = 1
            
            //setup text of labels
            if let playerDataInfo = DataManager.shared.getPlayerData() {
                let dollor = playerDataInfo.value(forKey: "currentDollor") as! Int
                let reputation = playerDataInfo.value(forKey: "currentReputation") as! Int
                dollorLabel?.text = String(dollor)
                reputationLabel?.text = String(reputation)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dollorLabel = self.childNode(withName: "//dollorLabel") as? SKLabelNode
        reputationLabel = self.childNode(withName: "//repuLabel") as? SKLabelNode
        backButton = self.childNode(withName: "//backButton") as? SKButton
        dollorLabel?.zPosition = 1
        reputationLabel?.zPosition = 1
        backButton?.zPosition = 1
        
        //setup text of labels
        if let playerDataInfo = DataManager.shared.getPlayerData() {
            let dollor = playerDataInfo.value(forKey: "currentDollor") as! Int
            let reputation = playerDataInfo.value(forKey: "currentReputation") as! Int
            dollorLabel?.text = String(dollor)
            reputationLabel?.text = String(reputation)
        }
    }
    
    convenience init() {
        self.init(texture: nil, color: UIColor.red, size: CGSize(width: 100, height: 100))
    }
    
    
}
