//
//  Character.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/14/21.
//

import UIKit
import SpriteKit

class Character: SKSpriteNode {
    var lives: Int!
    
    init(x:Int, y:Int, img:String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.lives = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
