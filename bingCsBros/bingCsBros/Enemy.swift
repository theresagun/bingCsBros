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
    var lastIntersectionTime: Double?
    var goombaMove: Int!
    var initMovement: CGFloat!
    var ogY: CGFloat!
    var ogX: CGFloat!
    
    init(x:Int, y:Int, img:String, typeOfEnemy: String, id: Int) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.initMovement = CGFloat(-1)
        self.ogY = CGFloat(y)
        self.ogX = CGFloat(x)
        self.typeOfEnemy = typeOfEnemy //types are goomba, fly, thwomp
//        switch typeOfEnemy {
//        case "goomba":
//            goombaMove = -1
//        default:
//            print("invalid type")
//        }
//        self.goombaMove = -1
        self.size.width = 64
        self.size.height = 75
        self.name = "Enemy"
        self.id = id
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
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
    
    func idleMovement(){
        if (typeOfEnemy == "goomba"){
            //should move back and forth?
            self.moveBackward()
        }
        else if(typeOfEnemy == "fly"){
            //should move up and down, swoop?
            self.moveBackward()
            self.position.y += self.initMovement
            if(abs(self.position.y - self.ogY) >= 15){
                self.initMovement = -(self.initMovement)
            }
        }
        else if(typeOfEnemy == "thwomp"){
            //shake and drop, go back up
            self.moveBackward()
            if(self.position.x <= self.ogX - 300 && self.position.y <= self.ogY){
                //go back up
                self.physicsBody?.affectedByGravity = false
                self.position.y += 1
                self.physicsBody?.collisionBitMask = UInt32(1) //can now go through physics world
            }
            else if(self.position.x <= self.ogX - 150){
                //time to drop
                self.physicsBody?.isDynamic = true
                self.physicsBody?.affectedByGravity = true
            }
            else if(self.position.x <= self.ogX-50){
                //shake
                self.position.y += self.initMovement
                if(abs(self.position.y - self.ogY) >= 1){
                    self.initMovement = -(self.initMovement)
                }
            }
            
        }
    }
}
