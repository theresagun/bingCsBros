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
    init(x:Int, y:Int, powerType:String) {
        var img = ""
        switch powerType {
        case "Immunity":
            img = "aPlus"
        case "SpeedBoost":
            img = "coffee"
        default:
            img = ""
        }
        let texture = SKTexture(imageNamed: img)
        let sz = CGSize(width: 30, height: 40)
        super.init(texture: texture, color: UIColor.clear, size: sz)
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
            currChar.powerTimer = 400
//            let start = Date()
//            while(start.timeIntervalSinceNow < 5) {
//            }
//            currChar.hasImmunity = false
        }
        else if (power == "SpeedBoost") {
            currChar.charSpeed = 4.0
            currChar.powerTimer = 400
//            let start = Date()
//            while(start.timeIntervalSinceNow < 5) {
//            }
           // currChar.charSpeed = 2.0
        }
    }
}
