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
            if self.logicStatus == .watingForStake {
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
    var playerPointLabel: SKLabelNode?
    var gapOfCards : Int = 34
    
    //vars of datas
    //house and relatedFunctionary will be init before scene has been present from fightSelectScene
    var house : House?
    var relatedFunctionary: Functionary?
    var playerInfo = DataManager.shared.getPlayerData()
    
    //vars of game logic
    var logicStatus : gameLogicStatus = .watingForStake
    var preStake: Int?
    var cards:[Card] = Card.getWholeCards(multiper: 2)
    var presentedCards:[Card] = [Card]()
    var usedCards:[Card] = [Card]()
    var playerCards:[Card] = [Card]()
    var functionaryCards: [Card] = [Card]()
    var playerCurrentPoint :Int?
    var playerAnotherPoint: Int?
    var functionaryCurrentPoint : Int?
    var functionaryAnotherPoint : Int?
    
    
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
        //change player's dollor and animate player's dollor label
        let currentDollor = playerCurrentDollor - givenStake
        playerInfo?.setValue(currentDollor, forKey: "currentDollor")
        let action = SKAction.customAction(withDuration:0.3, actionBlock: {
            labelNode,time in
            if let node = labelNode as? SKLabelNode {
                let range = givenStake
                let temp = Float((time/0.3)) * Float(range)
                let temp1 = Int(ceil(temp))
                let animationedCurrentDollor = playerCurrentDollor - temp1
                node.text = String(animationedCurrentDollor)
            }
        })
        action.timingMode = .easeInEaseOut
        naviBar?.dollorLabel?.run(action)
        //setup bet label
        betLabel?.text = "bet :"+" $ " + String(givenStake)
        betLabel?.isHidden = false
    }
    func distributOneCardToPlayer() {
        //datas
        let randomNum = Int(arc4random()) % cards.count
        let selectedCard = cards[randomNum]
        playerCurrentPoint = (playerCurrentPoint == nil) ? selectedCard.value : playerCurrentPoint! + selectedCard.value
        cards.remove(at: randomNum)
        presentedCards.append(selectedCard)
        
        //performance
        
    }
    func layoutItemsHorizontallyCentered(originPoint givenPoint:CGPoint, gap givenGap:Float, items givenItems:[SKNode]) {
        guard items.count > 0 else{
            return
        }
        let wholeLengh = (items.count - 1) * gap + givenItems[0].size.width
        let leftSideOffsetX = originPoint.x - wholeLengh/2
        for (index,oneItem) in givenItems {
            oneItem.position.x = leftSideOffsetX + oneItem.size.width/2 + index * gap
        }
    }
}
