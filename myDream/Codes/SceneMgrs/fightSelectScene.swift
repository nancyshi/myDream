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
    //vars of uiElements
    var backButton : SKButton?
    var scrollNode : SKScrollNode = SKScrollNode()
    var houseItems = [HouseItem]()
    //vars of datas
    var houses: [House] = []
    var functionarys: [Functionary] = []
    
    override func didMove(to view: SKView) {
        
        self.setUpDatas()
        self.setUpDefaultView()
        self.changeDefaultViewByData()
        if let contentLayer = self.childNode(withName: "contentLayer"){
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
    func setUpDatas() {
        guard let houseTemp = DataManager.shared.loadJsonData(fileName: "houseConfig", givenType: [House].self),
            let functionaryTemp = DataManager.shared.loadJsonData(fileName: "functionaryConfig", givenType: [Functionary].self) else {
                return
        }
        houses = houseTemp
        functionarys = functionaryTemp
    }
    func setUpDefaultView() {
        //back button
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
        //content
        let maskNode = SKSpriteNode.init()
        maskNode.size = CGSize(width: 414, height: 672)
        maskNode.position = CGPoint(x: 0, y: -31.545)
        maskNode.color = UIColor.red
        scrollNode.maskNode = maskNode
        
        scrollNode.container.size = maskNode.size
        scrollNode.refreshPropoties()
        scrollNode.setContainerTopOrBottom(top: true)

    }
    
    func changeDefaultViewByData() {
        for oneHouse in houses {
            let oneHouseItem = HouseItem.init(aHouse: oneHouse)
            for oneFunctionary in functionarys {
                if oneHouse.functionaryId == oneFunctionary.id {
                    let texture = SKTexture(imageNamed: oneFunctionary.headIconName)
                    oneHouseItem.headIconNode.texture = texture
                    break
                }
            }
            
            oneHouseItem.target = self
            houseItems.append(oneHouseItem)
        }
        let gapOfHouseItems:CGFloat = 13
        let gapOfHouseItemToTopContainer:CGFloat = 22
        let containerMinHeight = gapOfHouseItemToTopContainer + houseItems[0].size.height * CGFloat(houseItems.count) + gapOfHouseItems * CGFloat(houseItems.count)
        
        scrollNode.container.size.height = containerMinHeight
        scrollNode.refreshPropoties()
        scrollNode.setContainerTopOrBottom(top: true)
        var index = 0
        for oneHouseItem in houseItems {
            let yDistantFromTop = gapOfHouseItemToTopContainer + oneHouseItem.size.height/2 + (oneHouseItem.size.height + gapOfHouseItems) * CGFloat(index)
            let yPosition = scrollNode.container.size.height/2 - yDistantFromTop
            oneHouseItem.position = CGPoint(x: 0, y: yPosition)
            scrollNode.container.addChild(oneHouseItem)
            index = index + 1
        }
    }
}
