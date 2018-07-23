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
            backButton?.position = CGPoint(x: -162.613, y: 323.4)
            backButton?.zPosition = 3
            self.addChild(backButton!)
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
