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
    var hasImmunity: Bool!
    var charSpeed: CGFloat!
    
    init(x:Int, y:Int, img:String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.lives = 3
        self.hasImmunity = false
        self.charSpeed = 2.0
        //physics body should be the size of the img once we have one
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        //character stays upright
        self.physicsBody?.allowsRotation = false
        //next two are needed to make gravity work
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveForward(){
        self.position.x += charSpeed
    }

    func moveBackward(){
        self.position.x -= charSpeed
    }
    
    func jump(){
        //we can change dy if we want
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
    }
}
