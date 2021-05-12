//
//  PlatformBox.swift
//  bingCsBros
//
//  Created by Binghamton Dev on 4/20/21.
//

import UIKit
import SpriteKit

class PlatformBox: SKSpriteNode {
    var isQuestion: Bool!
    var img: String!
    var powerType: String?
    
    init(x:Int, y:Int, isQ:Bool) {
        self.isQuestion = isQ
        if(self.isQuestion) {
            print("is q true")
            self.img = "questionbox"
        }
        else {
            self.img = "marioblock"
        }
        let texture = SKTexture(imageNamed: self.img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.size.height = 20
        self.size.width = 20
        self.zPosition = 1
        self.name = "Platform"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //QuestionBox Interaction functions
}
