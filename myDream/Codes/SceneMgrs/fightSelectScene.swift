//
//  fightSelectScene.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/22.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData


class fightSelectScene: SKScene,SKButtonDelegate {
    //vars of uiElements
    var naviBar: NaviBar?
    var scrollNode : SKScrollNode = SKScrollNode()
    var houseItems = [HouseItem]()
    
    override func didMove(to view: SKView) {
        
        self.setUpDatas()
        self.setUpDefaultView()
        self.changeDefaultViewByData()
        if let contentLayer = self.childNode(withName: "contentLayer"){
            contentLayer.addChild(scrollNode)
        }
    }
    func onClick(button: SKButton) {
        if button == naviBar?.backButton! {
            if let scene = SKScene(fileNamed: "mainScene") {
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
        }
        else if button is HouseItem {
            if let scene = SKScene(fileNamed: "battleScene") as? battleScene {
                scene.scaleMode = .aspectFit
                scene.house = (button as! HouseItem).house
                scene.relatedFunctionary = DataManager.shared.getFunctionaryById(id: (scene.house?.functionaryId)!)
                self.view?.presentScene(scene)
            }
        }
    }
    func setUpDatas() {

        guard DataManager.shared.houseConfig != nil,
            DataManager.shared.functionaryConfig != nil else {
                print("no house or functionary data")
                return
        }
        
        //connect house data
        for oneHouse in DataManager.shared.houseConfig! {
            if let result = oneHouse.getSQLDataById(id: oneHouse.id) {
                //reset SQL data each time when the app launch , this is just for develop use
                DataManager.shared.persistentContainer.viewContext.delete(result)
                let relatedData = NSEntityDescription.insertNewObject(forEntityName: "HouseData", into: DataManager.shared.persistentContainer.viewContext)
                relatedData.setValue(oneHouse.id, forKey: "id")
                if oneHouse.sortOrder == 1 {
                    relatedData.setValue(1, forKey: "status")
                }
                else {
                    relatedData.setValue(0, forKey: "status")
                }
                
                
                
            }
            else {
                let relatedData = NSEntityDescription.insertNewObject(forEntityName: "HouseData", into: DataManager.shared.persistentContainer.viewContext)
                relatedData.setValue(oneHouse.id, forKey: "id")
                if oneHouse.sortOrder == 1 {
                    relatedData.setValue(1, forKey: "status")
                }
                else {
                    relatedData.setValue(0, forKey: "status")
                }
            }
        }
        DataManager.shared.saveData()
    }
    func setUpDefaultView() {
        //naviBar
        naviBar = self.childNode(withName: "//naviBar") as? NaviBar
        naviBar?.backButton?.target = self
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
        for oneHouse in DataManager.shared.houseConfig! {
            let oneHouseItem = HouseItem.init(aHouse: oneHouse)
            for oneFunctionary in DataManager.shared.functionaryConfig! {
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
        
        houseItems.sort(by: sortFunc(s1:s2:))
        var index = 0
        for oneHouseItem in houseItems {
            let yDistantFromTop = gapOfHouseItemToTopContainer + oneHouseItem.size.height/2 + (oneHouseItem.size.height + gapOfHouseItems) * CGFloat(index)
            let yPosition = scrollNode.container.size.height/2 - yDistantFromTop
            oneHouseItem.position = CGPoint(x: 0, y: yPosition)
            scrollNode.container.addChild(oneHouseItem)
            index = index + 1
        }
    }
    
    func sortFunc(s1:HouseItem,s2:HouseItem) -> Bool {
        return s1.house!.sortOrder < s2.house!.sortOrder
    }
}
