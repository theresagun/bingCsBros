//
//  PowerItem.swift
//  bingCsBros
//
//  Created by Binghamton Dev on 4/20/21.
//

import UIKit
import SpriteKit

class PowerItem: SKSpriteNode {
    var power: String!
    init(x:Int, y:Int, powerType:String, img:String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.power = powerType
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = false
        self.name = "powerItem"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func characterEffect(currChar:Character) {
        if(power == "Immunity") {
            currChar.hasImmunity = true
            let start = Date()
            while(start.timeIntervalSinceNow < 5) {
            }
            currChar.hasImmunity = false
        }
        else if (power == "SpeedBoost") {
            currChar.charSpeed = 4.0
            let start = Date()
            while(start.timeIntervalSinceNow < 5) {
            }
            currChar.charSpeed = 2.0
        }
    }
}
