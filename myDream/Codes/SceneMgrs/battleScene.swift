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
    case animating
}
enum gameResult{
    case playerWin
    case functionaryWin
    case normal
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
            guard button.isEnabled == true else {
                return
            }
            if self.logicStatus == .watingForStake {
                guard let currentDollor = playerInfo?.value(forKey: "currentDollor") as? Int else {
                    print("something wrong with get players current dollor")
                    return
                }
                guard currentDollor > 0 else {
                    print("you have no money baby")
                    return
                }
                self.decideStake(stake: (house?.minStake)!)
            }
            else if self.logicStatus == .watingForDecide {
                self.clickHint()
            }
        }
        else if button == button02 {
            guard button.isEnabled == true else {
                return
            }
            if self.logicStatus == .watingForStake {
                guard let currentDollor = playerInfo?.value(forKey: "currentDollor") as? Int else {
                    print("something wrong with get players current dollor")
                    return
                }
                guard currentDollor > 0 else {
                    print("you have no money baby")
                    return
                }
                if currentDollor >= (house?.maxStake)! {
                    self.decideStake(stake: (house?.maxStake)!)
                }
                else {
                    self.decideStake(stake: currentDollor)
                }
            }
            else if self.logicStatus == .watingForDecide {
                //stop
                self.clickStop()
            }
        }
        else if button == button03 {
            
        }
        else if button == button04 {
            guard button.isEnabled == true else {
                return
            }
            if self.logicStatus == .watingForStake {
                self.decideStake(stake: self.preStake!) // if prebutton is enabled , self.preStake will not be nil
            }
            else if self.logicStatus == .watingForDecide {
                
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
    var currentBet:Int? = nil
    
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
                print("there is something wrong with setup battle scene ui elements")
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
        self.setUpButtons()
        //here for develop use to avoid not enough dollor
        guard let currentDollor = playerInfo?.value(forKey: "currentDollor") as? Int else {
            print("something wrong with get players current dollor")
            return
        }
        if currentDollor == 0 {
            playerInfo?.setValue(1000, forKey: "currentDollor")
            DataManager.shared.saveData()
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
        self.currentBet = givenStake
        self.disabledAllButtons()
        //change player's dollor and animate player's dollor label
        let currentDollor = playerCurrentDollor - givenStake
        playerInfo?.setValue(currentDollor, forKey: "currentDollor")
        DataManager.shared.saveData()
        let dataForReport = DataForReport(type: .changeDollor, para: -givenStake)
        DataManager.shared.currentReportedData = dataForReport
        self.preStake = givenStake
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
        betLabel?.alpha = 1
        betLabel?.isHidden = false
        let betLabelAction = SKAction.customAction(withDuration: 0.3, actionBlock: {
            betLabelNode,time in
            if let node = betLabelNode as? SKLabelNode {
                let range = givenStake
                let temp = Float((time/0.3)) * Float(range)
                let temp1 = Int(ceil(temp))
                node.text = "bet :" + " $ " + String(temp1)
            }
        })
        betLabel?.run(SKAction.sequence([betLabelAction,SKAction.wait(forDuration: 0.5)]), completion: {
            self.distributeOneCard(to: self.player, isBack: false, completetion:{
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
                                self.logicStatus = .watingForDecide
                                self.setUpButtons()
                                let _ = self.checkTheResult(givenPlayer: self.player)
                            }, waitTime: 0.5)
                        }, waitTime: 0)
                    })
                }, waitTime: 0.5)
            }, waitTime: 0)
        })
    }
    func distributeOneCard(to givenPlayer:PlayerOfBlackJack,isBack givenIsBack:Bool,completetion:@escaping () -> Void,waitTime givenWaitTime:TimeInterval) {
        //set up datas
        if cards.count == 0 {
            cards = cards + usedCards
            usedCards.removeAll()
        }
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

    func setUpButtons() {
        if self.logicStatus == .watingForStake {
            self.button01?.buttonLabel.text = "Min"
            self.button02?.buttonLabel.text = "Max"
            self.button03?.buttonLabel.text = "Select"
            self.button04?.buttonLabel.text = "PreTime"
            for oneButton in [self.button01,self.button02,self.button03,self.button04] {
                if oneButton == self.button04 {
                    if self.preStake == nil {
                        oneButton?.isEnabled = false
                    }
                    else {
                        oneButton?.isEnabled = true
                    }
                }
                else {
                 oneButton?.isEnabled = true
                }
            }
        }
        else if self.logicStatus == .watingForDecide {
            self.button01?.buttonLabel.text = "Hint"
            self.button02?.buttonLabel.text = "Stop"
            self.button03?.buttonLabel.text = "Double"
            self.button04?.buttonLabel.text = "Deliver"
            for oneButton in [self.button01,self.button02,self.button03,self.button04] {
                if oneButton == self.button04 {
                    if self.player.cards.count == 2 && self.player.cards[0].value == self.player.cards[1].value {
                        oneButton?.isEnabled = true
                    }
                    else {
                        oneButton?.isEnabled = false
                    }
                }
                else {
                    oneButton?.isEnabled = true
                }
            }
        }
    }
    
    func disabledAllButtons() {
        for oneButton in [self.button01,self.button02,self.button03,self.button04] {
            oneButton?.isEnabled = false
        }
    }
    func checkTheResult(givenPlayer:PlayerOfBlackJack) -> gameResult {
        let point = givenPlayer.getFinalPoint()
        guard point <= 21 else {
            if givenPlayer.isFunctionary == true {
                self.showBustToPointLabel(givenPlayer: givenPlayer, compeletion: {
                    self.didWhilePlayerWin()
                }, waitting: 0.3)
                return gameResult.playerWin
            }
            else {
                self.showBustToPointLabel(givenPlayer: givenPlayer, compeletion: {
                    self.didWhilePlayerLose()
                }, waitting: 0.3)
                return gameResult.functionaryWin
            }
        }
        if point == 21 {
            if givenPlayer.isFunctionary == true {
                self.didWhilePlayerLose()
                return gameResult.functionaryWin
            }
            else {
                self.clickStop()
                return gameResult.normal
            }
        }
        else {
            if givenPlayer.isFunctionary == false {
                self.setUpButtons()
            }
            return gameResult.normal
        }
        
    }
    func showBustToPointLabel(givenPlayer:PlayerOfBlackJack,compeletion givenCompeletion:@escaping () -> Void, waitting givenWaitTime:TimeInterval) {
        let labelBg = self.getOneLabelNamed(name: "Bust")
        givenPlayer.pointLabel.addChild(labelBg)
        
        //animations
        let action = SKAction.scale(to: 1, duration: 0.3)
        action.timingMode = .easeInEaseOut
        let action1 = SKAction.scale(to: 0, duration: 0.3)
        action1.timingMode = .easeInEaseOut
        labelBg.run(SKAction.sequence([action,SKAction.wait(forDuration: 0.5),action1,SKAction.wait(forDuration: givenWaitTime),SKAction.run(givenCompeletion),SKAction.removeFromParent()]))
        
    }
    func didWhilePlayerLose() {
        //report
        let reportMessage = DataForReport(type: .loseGame, para: nil)
        DataManager.shared.currentReportedData = reportMessage
        let labelBg = self.getOneLabelNamed(name: "Lose")
        self.player.pointLabel.addChild(labelBg)
        
        //animations
        let action = SKAction.scale(to: 1, duration: 0.3)
        action.timingMode = .easeInEaseOut
        let action1 = SKAction.scale(to: 0, duration: 0.3)
        action1.timingMode = .easeInEaseOut
        labelBg.run(SKAction.sequence([action,SKAction.wait(forDuration: 0.5),action1,SKAction.removeFromParent()]), completion: {
            //hide betLabel and remove pointLabel
            self.betLabel?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.hide()]), completion: {
                self.betLabel?.text = "bet : $ 0"
            })
            self.functionary.pointLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.removeFromParent()]), completion: {})
            self.player.pointLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.removeFromParent()]), completion: {
                //remove all cards
                var moveAction = SKAction.move(by: CGVector(dx: -414, dy: 0), duration: 0.3)
                moveAction.timingMode = .easeInEaseOut
                moveAction = SKAction.sequence([moveAction,SKAction.removeFromParent()])
                for oneCard in self.player.cards {
                    oneCard.run(moveAction)
                }
                for indexTemp in 1 ... self.functionary.cards.count - 1 {  //you know  , there is at least 2 elements in functionary's cards while player lose
                    self.functionary.cards[indexTemp].run(moveAction)
                }
                self.functionary.cards[0].run(moveAction, completion: {
                    //clear all cards and setup datas
                    
                    for onePlayer in [self.player,self.functionary] {
                        onePlayer.cards.removeAll()
                        onePlayer.Point = 0
                        onePlayer.anotherPoint = nil
                    }
                    self.usedCards = self.usedCards + self.presentedCards
                    self.presentedCards.removeAll()
                    self.currentBet = nil
                    self.logicStatus = .watingForStake
                    self.setUpButtons()
                })
            })
        })
    }
    func  didWhilePlayerWin() {
        //report
        let reportMessage = DataForReport(type: .winGame, para: nil)
        DataManager.shared.currentReportedData = reportMessage
        let labelBg = self.getOneLabelNamed(name: "Win")
        self.player.pointLabel.addChild(labelBg)
        
        //animations
        let action = SKAction.scale(to: 1, duration: 0.3)
        action.timingMode = .easeInEaseOut
        let action1 = SKAction.scale(to: 0, duration: 0.3)
        action1.timingMode = .easeInEaseOut
        labelBg.run(SKAction.sequence([action,SKAction.wait(forDuration: 0.5),action1,SKAction.removeFromParent()]), completion: {
            //win the bet
            let actionRoll = SKAction.customAction(withDuration: 0.5, actionBlock: {
                oneNode,time in
                if let node = oneNode as? SKLabelNode {
                    let dollor = self.playerInfo?.value(forKey: "currentDollor") as! Int
                    let range = 2 * self.currentBet!
                    let current = (time/0.5) * CGFloat(range)
                    var current1 = Int(ceil(current))
                    current1 = current1 + dollor
                    node.text = String(current1)
                }
            })
            actionRoll.timingMode = .easeInEaseOut
            self.naviBar?.dollorLabel?.run(SKAction.sequence([actionRoll,SKAction.wait(forDuration: 0.3)]), completion: {
                //update datas
                let currentDollor = self.playerInfo?.value(forKey: "currentDollor") as! Int
                let willDollor = currentDollor + 2 * self.currentBet!
                self.playerInfo?.setValue(willDollor, forKey: "currentDollor")
                let reportM = DataForReport(type: .changeDollor, para: 2 * self.currentBet!)
                DataManager.shared.currentReportedData = reportM
                DataManager.shared.saveData()
                //hide betLabel and remove pointLabel
                self.betLabel?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.hide()]), completion: {
                    self.betLabel?.text = "bet : $ 0"
                })
                self.functionary.pointLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.removeFromParent()]), completion: {})
                self.player.pointLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.removeFromParent()]), completion: {
                    //remove all cards
                    var moveAction = SKAction.move(by: CGVector(dx: -414, dy: 0), duration: 0.3)
                    moveAction.timingMode = .easeInEaseOut
                    moveAction = SKAction.sequence([moveAction,SKAction.removeFromParent()])
                    for oneCard in self.player.cards {
                        oneCard.run(moveAction)
                    }
                    for indexTemp in 1 ... self.functionary.cards.count - 1 {  //you know  , there is at least 2 elements in functionary's cards while player lose
                        self.functionary.cards[indexTemp].run(moveAction)
                    }
                    self.functionary.cards[0].run(moveAction, completion: {
                        //clear all cards and setup datas
                        
                        for onePlayer in [self.player,self.functionary] {
                            onePlayer.cards.removeAll()
                            onePlayer.Point = 0
                            onePlayer.anotherPoint = nil
                        }
                        self.usedCards = self.usedCards + self.presentedCards
                        self.presentedCards.removeAll()
                        self.currentBet = nil
                        self.logicStatus = .watingForStake
                        self.setUpButtons()
                    })
                })
            })
        })
    }
    func clickHint() {
        self.disabledAllButtons()
        self.distributeOneCard(to: self.player, isBack: false, completetion: {
            self.player.setUpPointLabel()
            let _ = self.checkTheResult(givenPlayer: self.player)
        }, waitTime: 0.3)
    }
    func clickStop() {
        self.disabledAllButtons()
        self.player.pointLabel.text = String(self.player.getFinalPoint())
        //functionary's turn
        self.functionary.cards[1].cardNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.3),SKAction.setTexture(self.functionary.cards[1].originTexture!),SKAction.wait(forDuration: 0.3)]), completion: {
            self.functionary.setUpPointLabel()
            if let contentLayer = self.childNode(withName: "//gameContent") {
                self.functionary.pointLabel.alpha = 0
                contentLayer.addChild(self.functionary.pointLabel)
            }
            let actionA = SKAction.fadeAlpha(to: 1, duration: 0.3)
            let actionB = SKAction.wait(forDuration: 0.3)
            self.functionary.pointLabel.run(SKAction.sequence([actionA,actionB]), completion: {
                self.functionaryBehavior()
            })
        })
    }
    func getOneLabelNamed(name givenName:String) -> SKSpriteNode {
        let labelBg = SKSpriteNode(imageNamed: "labelBg")
        let labelNode = SKLabelNode(text: givenName)
        labelNode.fontName = "PingFang SC Semibold"
        labelNode.fontSize = 16
        labelNode.fontColor = UIColor.black
        labelNode.zPosition = 1
        labelNode.verticalAlignmentMode = .center
        labelBg.addChild(labelNode)
        labelBg.zPosition = 10
        labelBg.position = CGPoint(x: 63.862, y: 22.22)
        labelBg.setScale(0)
        return labelBg
    }
    func functionaryBehavior() {
        let playerFinalPoint = self.player.getFinalPoint()
        let functionaryFinalPoint = self.functionary.getFinalPoint()
        let result = self.checkTheResult(givenPlayer: self.functionary)
        if result == gameResult.normal {
            if functionaryFinalPoint < playerFinalPoint {
                self.button01!.run(SKAction.wait(forDuration: 0.3), completion: {
                    self.distributeOneCard(to: self.functionary, isBack: false, completetion: {
                        self.functionary.setUpPointLabel()
                        self.functionaryBehavior()
                    }, waitTime: 0.3)
                })
            }
            else {
                self.button01!.run(SKAction.wait(forDuration: 0.3), completion: {
                    self.didWhilePlayerLose()
                })
                
            }
        }

    }
}
