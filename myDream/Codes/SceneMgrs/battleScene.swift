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
        else if button == button01 {
            if button.buttonLabel.text == "Min" {
                self.decideStake(stake: (house?.minStake)!)
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
    
    //game content layer
    var betLabel: SKLabelNode?
    //vars of datas
    //house and relatedFunctionary will be init before scene has been present from fightSelectScene
    var house : House?
    var relatedFunctionary: Functionary?
    var playerInfo = DataManager.shared.getPlayerData()
    
    //vars of game logic
    var logicStatus : gameLogicStatus = .watingForStake
    var preStake: Int?
    
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
        betLabel = self.childNode(withName: "//betLabel") as? SKLabelNode
        guard naviBar != nil,
              functionaryNameLabel != nil,
              headIconNode != nil,
              interactButton != nil,
              button01 != nil,
              button02 != nil,
              button03 != nil,
              betLabel != nil,
              button04 != nil else {
                return
              }
        naviBar!.backButton?.target = self
        functionaryNameLabel!.text = relatedFunctionary?.name
        let texture = SKTexture(imageNamed: (relatedFunctionary?.imageName)!)
        headIconNode!.texture = texture
        
        for oneButton in [button01,button02,button03,button04] {
            oneButton?.target = self
            oneButton?.disabledTexture = SKTexture(imageNamed: "button_bg_disabled")
        }
        button01?.buttonLabel.text = "Min"
        button02?.buttonLabel.text = "Max"
        button03?.buttonLabel.text = "Select"
        button04?.buttonLabel.text = "PreTime"
        if self.preStake == nil {
            button04?.disabledColorForLabel = UIColor.white
            button04?.isEnabled = false
        }
    }
    func decideStake(stake givenStake:Int) {
        guard let playerCurrentDollor = playerInfo?.value(forKey: "currentDollor") as? Int else {
            print("something wrong to get play's current dollor")
            return
        }
        guard givenStake <= playerCurrentDollor else {
            print("not enough dollor")
            return
        }
        //buttons of operation layer will move down
        if let operationLayer = self.childNode(withName: "//operateLayer") {
            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 0.3)
            moveDown.timingMode = .easeInEaseOut
            operationLayer.run(moveDown)
        }
        //change player's dollor
        let currentDollor = playerCurrentDollor - givenStake
        playerInfo?.setValue(currentDollor, forKey: "currentDollor")
        naviBar?.dollorLabel?.text = String(currentDollor)
        
        //setup bet label
        betLabel?.text = "bet :"+" $ " + String(givenStake)
        betLabel?.isHidden = false
        
        
    }
    
    
}
