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
    var gapOfCards : Float = 34
    
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
    var player = PlayerOfBlackJack.init(isFunctionary: false)
    var functionary = PlayerOfBlackJack.init(isFunctionary: true)
    let insertCardAnimTime : TimeInterval = 0.3
    
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
//        if let operationLayer = self.childNode(withName: "//operateLayer") {
//            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 0.3)
//            moveDown.timingMode = .easeInEaseOut
//            operationLayer.run(moveDown)
//        }
        for oneButton in [self.button01,self.button02,self.button03,self.button04] {
            oneButton?.isEnabled = false
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
        
        self.distributeOneCard(to: player, isBack: false, completetion:{
            self.distributeOneCard(to: self.player, isBack: false, completetion: {
                
                //add player's point label
                self.player.setUpPointLabel()
                if let contentLayer = self.childNode(withName: "//gameContent") {
                    self.player.pointLabel.alpha = 0
                    contentLayer.addChild(self.player.pointLabel)
                }
                let action = SKAction.fadeAlpha(to: 1, duration: 0.1)
                let waitAction = SKAction.wait(forDuration: 0.5)
                self.player.pointLabel.run(SKAction.sequence([action,waitAction]), completion: {
                    self.distributeOneCard(to: self.functionary, isBack: false, completetion: {
                        self.distributeOneCard(to: self.functionary, isBack: true, completetion: {
                            if let operationLayer = self.childNode(withName: "//operateLayer") {
                                self.logicStatus = .watingForDecide
                                self.button01?.buttonLabel.text = "Stop"
                                self.button02?.buttonLabel.text = "Double"
                                self.button03?.buttonLabel.text = "Deliver"
                                self.button04?.buttonLabel.text = "Hint"
                                let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 0.3)
                                moveUp.timingMode = .easeInEaseOut
                                operationLayer.run(moveUp)
                            }
                        }, waitTime: 0.5)
                    }, waitTime: 0)
                })
            }, waitTime: 0.5)
        }, waitTime: 0)
    }
    func distributeOneCard(to givenPlayer:PlayerOfBlackJack,isBack givenIsBack:Bool,completetion:@escaping () -> Void,waitTime givenWaitTime:TimeInterval) {
        //set up datas
        let randomNum = Int(arc4random()) % cards.count
        let selectedCard = cards[randomNum]
        cards.remove(at: randomNum)
        givenPlayer.cards.append(selectedCard)
        presentedCards.append(selectedCard)
        givenPlayer.updatePointValues()
        //present performance
        if givenIsBack == true {
            selectedCard.cardNode.texture = selectedCard.cardBackTextureBlue
        }
        selectedCard.position = givenPlayer.isFunctionary ? CGPoint(x: 258.196, y: 57.412) : CGPoint(x: 258.196, y: -180.588)
        if let contentLayer = self.childNode(withName: "//gameContent") {
            contentLayer.addChild(selectedCard)
        }
        let originPoint = givenPlayer.isFunctionary ? CGPoint(x: 2.634, y: 57.412) : CGPoint(x: 2.634, y: -180.588)
        let cardsPositionsWillBe = givenPlayer.distributeCardsHorizontally(originPoint: originPoint, gap: gapOfCards)
        
        for index in 0 ... cardsPositionsWillBe.count - 1 {
            var action = SKAction.move(to: cardsPositionsWillBe[index], duration: insertCardAnimTime)
            action.timingMode = .easeInEaseOut
            if index == cardsPositionsWillBe.count - 1 {
                let waitAction = SKAction.wait(forDuration: givenWaitTime)
                let newAction = SKAction.sequence([action,waitAction,SKAction.run(completetion)])
                action = newAction
            }
            givenPlayer.cards[index].run(action)
        }
        
    }
    func setUpOperateLayerButtons(currentStatus givenStatus:gameLogicStatus) {
        if givenStatus == .watingForStake {
            self.button01?.buttonLabel.text = "Min"
            self.button02?.buttonLabel.text = "Max"
            self.button03?.buttonLabel.text = "Select"
            self.button04?.buttonLabel.text = "PreTime"
            for oneButton in [self.button01,self.button02,self.button03,self.button04] {
                oneButton?.isEnabled = true
            }
            if self.preStake == nil {
                button04?.disabledColorForLabel = UIColor.white
                button04?.isEnabled = false
            }
        }
        else if givenStatus == .watingForDecide {
            self.button01?.buttonLabel.text = "Stop"
            self.button02?.buttonLabel.text = "Double"
            self.button03?.buttonLabel.text = "Deliver"
            self.button04?.buttonLabel.text = "Hint"
            for oneButton in [self.button01,self.button02,self.button03,self.button04] {
                oneButton?.isEnabled = true
            }
            
        }
        
    }
    
}
