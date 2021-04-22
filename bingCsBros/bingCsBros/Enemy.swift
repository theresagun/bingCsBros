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
    var id: Int!
    
    init(x:Int, y:Int, img:String, typeOfEnemy: String, id: Int) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.typeOfEnemy = typeOfEnemy
        self.size.width = 64
        self.size.height = 75
        self.name = "Enemy"
        self.id = id
        self.zPosition = 1
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
