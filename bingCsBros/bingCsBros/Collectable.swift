//
//  Collectable.swift
//  bingCsBros
//
//  Created by Binghamton Dev on 4/20/21.
//

import UIKit
import SpriteKit

class Collectable: SKSpriteNode {
    var isCollected: Bool!
    init(x:Int, y:Int, img:String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.isCollected = false
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = false
        self.name = "collectible"
        self.size.width = 40
        self.size.height = 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
