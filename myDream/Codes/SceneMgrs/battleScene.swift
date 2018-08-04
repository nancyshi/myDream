//
//  battleScene.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/30.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit
enum gameLogicStatus {
    case watingForStake
    case watingForDecide
    
}
class battleScene: SKScene,SKButtonDelegate {
    func onClick(button: SKButton) {
        if button == naviBar?.backButton! {
            if let scene = SKScene(fileNamed: "fightSelectScene") as? fightSelectScene {
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
        }
    }
    //vars of ui elements
    //naviBar
    var naviBar: NaviBar?
    //functionary info
    var functionaryNameLabel : SKLabelNode?
    var headIconNode : SKSpriteNode?
    var interactButton: SKButton?
    //operate layer
    var button01: SKButton?
    var button02: SKButton?
    var button03: SKButton?
    var button04: SKButton?
    //vars of datas
    //house and relatedFunctionary will be init before scene has been present
    var house : House?
    var relatedFunctionary: Functionary?
    
    //vars of game logic
    var logicStatus : gameLogicStatus = .watingForStake
    
    override func didMove(to view: SKView) {

        //setup view
        naviBar = self.childNode(withName: "//naviBar") as? NaviBar
        functionaryNameLabel = self.childNode(withName: "//nameLabel") as? SKLabelNode
        headIconNode = self.childNode(withName: "//headIconNode") as? SKSpriteNode
        interactButton = self.childNode(withName: "//interactButton") as? SKButton
        button01 = self.childNode(withName: "//button01") as? SKButton
        button02 = self.childNode(withName: "//button02") as? SKButton
        button03 = self.childNode(withName: "//button03") as? SKButton
        button04 = self.childNode(withName: "//button04") as? SKButton
        
        guard naviBar != nil,
              functionaryNameLabel != nil,
              headIconNode != nil,
              interactButton != nil,
              button01 != nil,
              button02 != nil,
              button03 != nil,
              button04 != nil else {
                return
              }
        naviBar!.backButton?.target = self
        functionaryNameLabel!.text = relatedFunctionary?.name
        let texture = SKTexture(imageNamed: (relatedFunctionary?.imageName)!)
        headIconNode!.texture = texture
        
        button01?.buttonLabel.text = "Min"
        button02?.buttonLabel.text = "Max"
        button03?.buttonLabel.text = "Select"
        button04?.buttonLabel.text = "PreTime"
    }
    

    
}
