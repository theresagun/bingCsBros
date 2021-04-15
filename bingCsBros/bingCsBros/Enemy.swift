//
//  Enemy.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 4/15/21.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    var typeOfEnemy: String!
    
    init(x:Int, y:Int, img:String, typeOfEnemy: String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.typeOfEnemy = typeOfEnemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveForward(){
        self.position.x += CGFloat(1)
    }

    func moveBackward(){
        self.position.x -= CGFloat(1)
    }
}
