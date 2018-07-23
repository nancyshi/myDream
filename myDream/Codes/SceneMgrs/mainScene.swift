//
//  mainScene.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/21.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class mainScene: SKScene,SKButtonDelegate {
    
    var button_fight : SKButton?
    var button_relaxtion : SKButton?
    
    override func didMove(to view: SKView) {
        button_fight = self.childNode(withName: "button_fight") as? SKButton
        button_relaxtion = self.childNode(withName: "button_relaxtion") as? SKButton
        if button_fight != nil {
            button_fight?.target = self
            button_fight!.type = .Normal
            self.setLabel(label: button_fight!.buttonLabel,text: "Fight")
        }
        if button_relaxtion != nil {
            button_relaxtion?.target = self
            button_relaxtion!.type = .Normal
            self.setLabel(label: button_relaxtion!.buttonLabel,text: "Relaxtion")
        }
        print(self.frame)
        print(self.view!.frame)
    }
    func setLabel(label:SKLabelNode,text:String) {
        label.text = text
        label.fontName = "PingFang SC"
        label.fontColor = UIColor.white
        label.fontSize = 36
        label.position = CGPoint(x: 0, y: -40)
    }
    
    func onClick(button: SKButton) {
        
        if button == button_fight! {
            let moveLeft = SKAction.move(by: CGVector.init(dx: -400, dy: 0), duration: 0.2)
            moveLeft.timingMode = .easeInEaseOut
            
            let moveRight = SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 0.2)
            moveRight.timingMode = .easeInEaseOut
            
            let changeScene = SKAction.perform(#selector(self.changeScene), onTarget: self)
            
            let actions = SKAction.sequence([moveLeft,changeScene])
            button_fight?.run(actions)
            button_relaxtion?.run(moveRight)
            
        }
        
    }
    
    @objc func changeScene() {
        if let newScene = SKScene(fileNamed: "fightSelectScene") {
            newScene.scaleMode = .aspectFit
            self.view?.presentScene(newScene)
        }
    }
    
}
