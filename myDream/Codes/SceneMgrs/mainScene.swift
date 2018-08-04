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
    var naviBar :NaviBar?
    
    override func didMove(to view: SKView) {
        
        naviBar = self.childNode(withName: "//naviBar") as? NaviBar
        button_fight = self.childNode(withName: "button_fight") as? SKButton
        button_relaxtion = self.childNode(withName: "button_relaxtion") as? SKButton
        guard button_fight != nil,
            button_relaxtion != nil else {
                print("no button_fight or button_relaxtion")
                return
        }
        button_fight!.target = self
        button_relaxtion!.target = self
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
