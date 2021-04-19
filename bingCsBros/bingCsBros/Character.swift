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
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        //character stays upright
        self.physicsBody?.allowsRotation = false
        //next two are needed to make gravity work
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveForward(){
        self.position.x += CGFloat(2)
    }

    func moveBackward(){
        self.position.x -= CGFloat(2)
    }
    
    func jump(){
        //we can change dy if we want
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
    }
}
