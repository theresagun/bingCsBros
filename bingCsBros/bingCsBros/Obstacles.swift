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
    var id: Int!
    
    init(x:Int, y:Int, img:String, typeOfObstacles: String, id: Int) {
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.typeOfObstacles = typeOfObstacles
        self.size.width = 64
        self.size.height = 75
        self.name = "Obstacle"
        self.id = id
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
