//
//  SKButton.swift
//  button
//
//  Created by 石皓云 on 2018/7/21.
//  Copyright © 2018年 石皓云. All rights reserved.
//

enum SKButtonType {
    case Normal   //with a backGround and a label
    case Label    //just with a label
    case BackGround //just with a background
}

enum SKButtonStatus {
    case Normal
    case Hold
}

import UIKit
import SpriteKit
protocol SKButtonDelegate {
    func onClick(button:SKButton)
}

class SKButton: SKSpriteNode {
    
    
    
    var type = SKButtonType.BackGround {
        didSet(old) {
            if type == .Label {
                buttonLabel.isHidden = false
                self.texture = nil
                self.color = UIColor.clear
            }
            else if type == .Normal {
                buttonLabel.isHidden = false
            }
            else if type == .BackGround {
                buttonLabel.isHidden = true
            }
        }
    }
    var status = SKButtonStatus.Normal{
        didSet(old) {
            if status != old {
                if type == .BackGround {
                    if self.holdTexture != nil {
                        let temp = self.texture
                        self.texture = self.holdTexture
                        self.holdTexture = temp
                    }
                }
                else if type == .Label {
                    let temp = buttonLabel.fontColor
                    buttonLabel.fontColor = self.holdColorForLabel
                    self.holdColorForLabel = temp!
                    
                }
                else if type == .Normal {
                    if self.holdTexture != nil {
                        let temp = self.texture
                        self.texture = self.holdTexture
                        self.holdTexture = temp
                    }
                }
            }
        }
    }
    var buttonLabel:SKLabelNode = SKLabelNode(text: "buttonLabel")
    var buttonLabelSize:CGSize {
        get {
            return buttonLabel.frame.size
        }
        set {
           self.size = buttonLabelSize
        }
    }
    var holdTexture:SKTexture?
    var holdColorForLabel = UIColor.red
    var target : SKButtonDelegate?
    var isResponseMoved = true
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
        buttonLabel.zPosition = self.zPosition + 1
        buttonLabel.isHidden = true
        self.addChild(buttonLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        buttonLabel.zPosition = self.zPosition + 1
        buttonLabel.isHidden = true
        self.addChild(buttonLabel)
    }
    
    convenience init(type:SKButtonType) {
        self.init(texture: nil, color: UIColor.red, size: CGSize(width: 100, height: 100))
        if type == SKButtonType.Normal {
            self.type = .Normal
            buttonLabel.isHidden = false
        }
        else if type == SKButtonType.Label {
            self.type = .Label
            buttonLabel.isHidden = false
            self.color = UIColor.clear
            self.size = buttonLabel.frame.size
        }
        else if type == SKButtonType.BackGround {
        }
    }
    
    convenience init(imageNamed:String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: UIColor.red, size: texture.size())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            if self.status == SKButtonStatus.Normal {
               // print("touch began ,change from normal to hold")
                self.status = SKButtonStatus.Hold
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isResponseMoved == true {
            if self.status == .Hold {
                if let touch = touches.first {
                    let location = touch.location(in: self.parent!)
                    if !self.contains(location) {
                        self.status = .Normal
                    }
                }
            }
        }
        else {
            if self.status == .Hold {
                self.status = .Normal
            }
            self.parent?.touchesMoved(touches, with: event)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            if self.status == SKButtonStatus.Hold {
                self.status = .Normal
                if target != nil {
                    target!.onClick(button: self)
                }
                else {
                    print("This button has no target, please set up a target")
                }
            }
        }
    }
}
