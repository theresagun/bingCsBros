//
//  Obstacles.swift
//  bingCsBros
//
//  Created by Jack Curtin on 4/15/21.
//


import UIKit
import SpriteKit

class Obstacles: SKSpriteNode {
    var typeOfObstacles: String!
    
    init(x:Int, y:Int, img:String, typeOfObstacles: String) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.typeOfObstacles = typeOfObstacles
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
