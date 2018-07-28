//
//  fightSelectScene.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/22.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit


class fightSelectScene: SKScene,SKButtonDelegate {
    
    var backButton : SKButton?
    override func didMove(to view: SKView) {
        backButton = SKButton.init(type: .Label)
        if backButton != nil {
            //config back label
            backButton?.target = self
            backButton?.buttonLabel.text = "< BACK"
            backButton?.buttonLabel.fontName = "PingFang SC"
            backButton?.buttonLabel.fontSize = 20
            backButton?.position = CGPoint(x: -162.613, y: -6.1)
            if let nav = self.childNode(withName: "naviBar") as? SKSpriteNode {
                nav.addChild(backButton!)
            }
        }
        
        //test
        let scrollNode = SKScrollNode.init()
        let maskNode = SKSpriteNode.init()
        maskNode.size = CGSize(width: 414, height: 672)
        maskNode.position = CGPoint(x: 0, y: -31.545)
        maskNode.color = UIColor.red
        scrollNode.maskNode = maskNode
        scrollNode.container.size = CGSize(width: maskNode.size.width, height: maskNode.size.height + 300)
        scrollNode.refreshPropoties()
        
        let testHouse = HouseItem.init()
        testHouse.isResponseMoved = false
        testHouse.target = self
        scrollNode.container.addChild(testHouse)
        
        
        if let contentLayer = self.childNode(withName: "contentLayer")  {
            contentLayer.addChild(scrollNode)
        }

        
    }
    func onClick(button: SKButton) {
        if button == backButton! {
            if let scene = SKScene(fileNamed: "mainScene") {
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
        }
        else {
            print("some button has been clicked")
        }
    }
}
