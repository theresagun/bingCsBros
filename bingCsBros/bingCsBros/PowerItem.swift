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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func characterEffect(currChar:Character) {
        if(power == "Immunity") {
            currChar.hasImmunity = true
        }
        else if (power == "SpeedBoost") {
            currChar.charSpeed = 4.0
        }
    }
}
