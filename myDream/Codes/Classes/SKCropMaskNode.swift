//
//  SKCropMaskNode.swift
//  myDream
//
//  Created by 石皓云 on 2018/7/23.
//  Copyright © 2018年 石皓云. All rights reserved.
//

import UIKit
import SpriteKit

class SKCropMaskNode: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hey")
    }
}
