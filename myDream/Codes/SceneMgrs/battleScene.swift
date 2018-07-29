//
//  battleScene.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/30.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class battleScene: SKScene,SKButtonDelegate {
    func onClick(button: SKButton) {
        
    }
    
    var menuButton : SKButton?
    var interactButton : SKButton?
    var functionaryNameLabel : SKLabelNode?
    var headIconNode : SKSpriteNode?
    var funcDollorLabel : SKLabelNode?
    var house : House?
    
    override func didMove(to view: SKView) {
        menuButton = self.childNode(withName: "//menuButton") as? SKButton
        interactButton = self.childNode(withName: "//interactButton") as? SKButton
        functionaryNameLabel = self.childNode(withName: "//nameLabel") as? SKLabelNode
        headIconNode = self.childNode(withName: "//headIconNode") as? SKSpriteNode
        funcDollorLabel = self.childNode(withName: "//funcDollorLabel") as? SKLabelNode
        guard menuButton != nil,
            interactButton != nil,
            functionaryNameLabel != nil,
            headIconNode != nil,
            funcDollorLabel != nil else {
                print("something wrong with setup elements")
                return
        }
        self.setUpButtonLabel(button: menuButton!, labelText: "Menu")
        self.setUpButtonLabel(button: interactButton!, labelText: "Interact")
        
        guard house != nil else {
            print("something wrong with get house data")
            return
        }
        funcDollorLabel!.text = "$ " + String(house!.originDollor)
        guard let functionarys = DataManager.shared.loadJsonData(fileName: "functionaryConfig", givenType: [Functionary].self) else {
            return
        }
        for oneFunc in functionarys {
            if house!.functionaryId == oneFunc.id {
                functionaryNameLabel?.text = oneFunc.name
                self.headIconNode!.texture = SKTexture(imageNamed: oneFunc.headIconName)
                break
            }
        }
        
    }
    
    func setUpButtonLabel(button oneButton:SKButton,labelText text:String) {
        oneButton.buttonLabel.text = text
        oneButton.buttonLabel.fontName = "PingFang SC Semibold"
        oneButton.buttonLabel.fontSize = 16
        oneButton.buttonLabel.verticalAlignmentMode = .center
        oneButton.buttonLabel.isHidden = false
        
        oneButton.target = self
    }
    
}
