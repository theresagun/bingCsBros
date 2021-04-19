//
//  GameScene.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/12/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var good:Bool = false

    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //needed for gravity/jumping
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5) //can change dy if we want
        //so nodes don't fall off the screen
        let physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsBody = physicsBody

        //testing jumping, we can remove this later 
        let mainChar = Character(x: 0, y: 0, img: "someName")
        mainChar.zPosition = 1
        addChild(mainChar)
        createBackground()
        

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //jump
        if(pos.x > -180 && pos.x < 180){
            NSLog("I'm a dinosaur and I like to jump.")
            (self.children[0] as! Character).jump()

            
        }
        //right
        if(pos.x < -180){
            NSLog("I'm a dinosaur and I like to run right.")
            (self.children[0] as! Character).moveBackward()
            callBack_backward()

            
        }
        //left
        if(pos.x > 180){
            NSLog("I'm a dinosaur and I like to run left.")
            callBack_forward()
        }
    }
    
    func callBack_forward() {
        (self.children[0] as! Character).moveForward()
        if(good == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                self.callBack_forward()
            }
        }
    }
    func callBack_backward() {
        (self.children[0] as! Character).moveBackward()
        if(good == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                self.callBack_backward()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        good = true
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        good = false
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBackground()
    }
    
    func createBackground(){
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "bartle.jpeg")
            background.name = "Background"
            background.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            background.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
           background.position = CGPoint(x: CGFloat(i)*background.size.width, y: 0)
            background.zPosition = 0
            self.addChild((background))
        }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "Background", using: ({
            (node,error) in

            node.position.x -= 2

            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }) )
    }

    
    
    
    
}



    

    


    
