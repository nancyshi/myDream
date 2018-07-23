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
    
    var backButton : SKButton?
    override func didMove(to view: SKView) {
        backButton = SKButton.init(type: .Label)
        if backButton != nil {
            //config back label
            backButton?.target = self
            backButton?.buttonLabel.text = "< BACK"
            backButton?.buttonLabel.fontName = "PingFang SC"
            backButton?.buttonLabel.fontSize = 20
            backButton?.position = CGPoint(x: -162.613, y: 323.4)
            backButton?.zPosition = 3
            self.addChild(backButton!)
        }
        //test1
        let scrollNode = SKScrollNode.init()
        scrollNode.zPosition = 4
        scrollNode.container.isUserInteractionEnabled = false
        

        let maskNode = SKCropMaskNode(color: UIColor.blue, size: CGSize(width: 413.999, height: 672.909))
        maskNode.zPosition = 5
        maskNode.position = CGPoint(x: 0, y: -31.545)

        scrollNode.maskNode = maskNode
        let testHouse = HouseItem.init()
        testHouse.zPosition = 6
        testHouse.isResponseMoved = false
        scrollNode.container.size = maskNode.size
        scrollNode.container.size.height = scrollNode.container.size.height + 200
        scrollNode.container.position = maskNode.position
        scrollNode.container.addChild(testHouse)

        self.addChild(scrollNode)
        
        //test2 uikit
//        let scrollView = UIScrollView.init()
//        let widthFactor = CGFloat(413.999/414)
//        let heightFctor = CGFloat(672.909/750)
//
//        scrollView.frame.size = CGSize.init(width: self.view!.frame.width * widthFactor, height: self.view!.frame.height * heightFctor)
//        print("view fram is \(self.view!.frame)")
//
//
//        let centerPointInView = self.convertPoint(toView: CGPoint(x: 0, y: -31.545))
//        scrollView.center = centerPointInView
//        scrollView.backgroundColor = UIColor.white
//        //scrollView.contentMode = .scaleAspectFit
//        self.view?.addSubview(scrollView)
//        print(scrollView.frame)
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
}
