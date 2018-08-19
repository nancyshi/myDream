//
//  Notification.swift
//  myDream
//
//  Created by 石皓云 on 2018/8/19.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit
enum NotificationType {
    case needConform
    case fadeOver
}

class Notification: SKNode,SKButtonDelegate {
    func onClick(button: SKButton) {
        if button == self.okButton {
            guard button.isEnabled == true else {
                return
            }
            if self.parent != nil {
                self.removeFromParent()
            }
        }
    }
    
    
    var textBg : SKSpriteNode = SKSpriteNode.init(texture: nil, color: UIColor.init(red: 0.3137, green: 0.3137, blue: 0.3137, alpha: 1), size: CGSize.init(width: 500, height: 100))
    var notiLabel : SKLabelNode = SKLabelNode(text: "default")
    var okButton : SKButton = SKButton.init(type: .Normal)
    var bg : SKSpriteNode = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: 420, height: 740))
    var type : NotificationType = .needConform
    var waittingTime:TimeInterval = 2 //just use for fadeover type
    
    override init() {
        super.init()
        bg.alpha = 0.5
        bg.zPosition = 1
        textBg.zPosition = 2
        notiLabel.zPosition = 3
        okButton.zPosition = 4
        
        self.addChild(bg)
        self.addChild(textBg)
        
        notiLabel.numberOfLines = 0
        notiLabel.fontName = "PingFang SC Semibold"
        notiLabel.fontSize = 20
        notiLabel.verticalAlignmentMode = .center
        notiLabel.preferredMaxLayoutWidth = 400
        self.addChild(notiLabel)
        
        okButton.buttonLabel.fontSize = 20
        okButton.buttonLabel.fontName = "PingFang SC Semibold"
        okButton.color = UIColor.init(red: 0.3137, green: 0.3137, blue: 0.3137, alpha: 1)
        okButton.size = SKTexture(imageNamed: "ok_button").size()
        okButton.texture = SKTexture(imageNamed: "ok_button")
        okButton.buttonLabel.text = "OK"
        okButton.buttonLabel.verticalAlignmentMode = .center
        okButton.target = self
        self.addChild(okButton)
    }
    
    convenience init(text givenText:String, type givenType:NotificationType) {
        self.init()
        self.type = givenType
        notiLabel.text = givenText
        
        textBg.size.height = notiLabel.frame.size.height + 20
        let buttomY = -textBg.size.height/2
        okButton.position.y = buttomY
        
        switch givenType {
        case .fadeOver:
            bg.color = UIColor.clear
            okButton.removeFromParent()
            break
        default:
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func showNotification(notification givenNotification:Notification,to givenNode:SKNode,animationed givenAnimationed:Bool) {
        givenNotification.zPosition = 1000
        if givenAnimationed == true {
            givenNotification.setScale(0)
            givenNode.addChild(givenNotification)
            let actionA = SKAction.scale(to: 1, duration: 0.3)
            actionA.timingMode = .easeInEaseOut
            let actionB = SKAction.scale(to: 0, duration: 0.3)
            actionB.timingMode = .easeInEaseOut
            
            let actionSeq = givenNotification.type == .needConform ? actionA : SKAction.sequence([actionA,SKAction.wait(forDuration: givenNotification.waittingTime),actionB,SKAction.removeFromParent()])
            givenNotification.run(actionSeq)
        }
        else {
            givenNode.addChild(givenNotification)
            if givenNotification.type == .fadeOver {
                let actionSeq = SKAction.sequence([SKAction.wait(forDuration: givenNotification.waittingTime),SKAction.removeFromParent()])
                givenNotification.run(actionSeq)
            }
        }
    }
}
