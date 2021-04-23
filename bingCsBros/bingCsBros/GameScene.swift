//
//  GameScene.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/12/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var good:Bool = false
    var startOfLevel = DispatchTime.now()
    var level = 1 //make this persistent
    var intervalsUsed : [Int] = []
    var notOnScreen : [String] = []
    var collected : [SKNode] = []
    var score = 0
    var livesHelper: Int!
    
    var scoreLabel: SKLabelNode!
    var healthLabel: SKLabelNode!
        
    enum collisionTypes: UInt32 {
        case player = 1
        case enemy = 2
        case obstacle = 4
        case power = 8
        case collectible = 16
        case platform = 32
    }
    
    override func didMove(to view: SKView) {
        //needed for gravity/jumping
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5) //can change dy if we want
        //so nodes don't fall off the screen
        //this is hard coded for an iphone 11 in landscape mode with camera on right
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.midY-165), size: self.frame.size))
        //for future reference:
        //bottom left corner CGPoint(x: self.frame.minX, y: self.frame.midY-165)
        //top right corner CGPoint(x: self.frame.maxX, y: self.frame.midY+165)
        
        //testing jumping, we can remove this later 
        let mainChar = Character(x: 0, y: 0, img: "someName")
        mainChar.zPosition = 1
        mainChar.name = "mainChar"
        
        //what type of object is this
        mainChar.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
        //what do we want to be notified of colliding with
        mainChar.physicsBody?.contactTestBitMask = collisionTypes.enemy.rawValue | collisionTypes.power.rawValue | collisionTypes.collectible.rawValue
        //what do we not want to walk through
        mainChar.physicsBody?.collisionBitMask = collisionTypes.obstacle.rawValue | collisionTypes.platform.rawValue
        
        self.livesHelper = mainChar.lives
        addChild(mainChar)
        createBackground()
        setUpLabels()
    }
    
    func didBegin(_ contact: SKPhysicsContact) { //called when beginning of a collision is detected
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "mainChar" {
            playerCollided(with: nodeB)
        } else if nodeB.name == "mainChar" {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode){
        if node.name == "Enemy"{
            (self.childNode(withName: "mainChar") as! Character).lives -= 1
            self.livesHelper -= 1
        }
        else if node.name == "powerItem"{
            (node as! PowerItem).characterEffect(currChar: (self.childNode(withName: "mainChar") as! Character))
            node.removeFromParent()
        }
        else if node.name == "collectible"{
            (node as! Collectable).isCollected = true
            self.collected.append(node) //keep track of ones we collected
            node.removeFromParent() //remove from screen
        }
        
    }
    
    func setUpLabels(){
        let viewTop = CGPoint(x:scene!.view!.center.x,y:scene!.view!.frame.minY)
        let sceneTop = scene!.view!.convert(viewTop, to:scene!)
        let nodeTop = scene!.convert(sceneTop,to:GameScene())
        //create score label
          self.scoreLabel = SKLabelNode(fontNamed: "Courier")
          self.scoreLabel.name = "scoreLabel"
          self.scoreLabel.fontSize = 20
          self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.text = String(format: "Score: %04u", self.score)
          self.scoreLabel.position = CGPoint(x: nodeTop.x + 200, y: nodeTop.y-50)
        addChild(scoreLabel)

        //same for health TODO change health to hearts not %
          self.healthLabel = SKLabelNode(fontNamed: "Courier")
          self.healthLabel.name = "healthLabel"
          self.healthLabel.fontSize = 20
          self.healthLabel.fontColor = SKColor.white
        self.healthLabel.text = String(format: "Health: 3")
          self.healthLabel.position = CGPoint(x: nodeTop.x - 200, y: nodeTop.y-50)
        addChild(healthLabel)
    }
    
    func updateLabels(){
        self.scoreLabel.text = String(format: "Score: %04u", self.score)
        self.healthLabel.text = String(format: "Health: %04u", self.livesHelper)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //jump
        if(pos.x > -180 && pos.x < 180){
           // NSLog("I'm a dinosaur and I like to jump.")
            (self.children[0] as! Character).jump()

            
        }
        //right
        if(pos.x < -180){
          //  NSLog("I'm a dinosaur and I like to run right.")
            (self.children[0] as! Character).moveBackward()
            callBack_backward()

            
        }
        //left
        if(pos.x > 180){
          //  NSLog("I'm a dinosaur and I like to run left.")
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
        var timeInterval = 0.0
        if(level == 1 ){
            //print("level == 1")
            //declare all enemies/obstacles
            let enemy1 = Enemy(x: Int(self.frame.maxX) - 250, y: 0, img: "steven", typeOfEnemy: "goomba", id: 1)
            enemy1.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy1.physicsBody?.collisionBitMask = 0
            
            let obstacle1 = Obstacles(x: Int(self.frame.maxX) - 200, y: 0, img: "desk", typeOfObstacles: "idk?", id: 2)
            obstacle1.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
            obstacle1.physicsBody?.isDynamic = false

            let enemy2 = Enemy(x: Int(self.frame.maxX) - 250, y: 0, img: "madden", typeOfEnemy: "goomba", id: 3)
            enemy2.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy2.physicsBody?.collisionBitMask = 0

            let platform1 : [SKNode] = makePlatform(x: 100 , y: 0, numBoxes: 5, numQBoxes: 1)
            
            let obstacle2 = Obstacles(x: Int(self.frame.maxX) - 200, y: 0, img: "chair", typeOfObstacles: "idk?", id: 4)
            obstacle2.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
            obstacle2.physicsBody?.isDynamic = false
            
            let enemy3 = Enemy(x: Int(self.frame.maxX) - 250, y: 0, img: "steven", typeOfEnemy: "goomba", id: 5)
            enemy3.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy3.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy3.physicsBody?.collisionBitMask = 0
            
            let platform2 : [SKNode] = makePlatform(x: Int(self.frame.minX) + 60 , y: 100, numBoxes: 5, numQBoxes: 0)
            
            let platform3 : [SKNode] = makePlatform(x: 0 , y: 0, numBoxes: 5, numQBoxes: 1)
            
            let obstacle3 = Obstacles(x: Int(self.frame.maxX) - 200, y: 0, img: "desk", typeOfObstacles: "idk?", id: 6)
            obstacle3.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
            obstacle3.physicsBody?.isDynamic = false
            
            let platform4 : [SKNode] = makePlatform(x: 0 , y: 0, numBoxes: 3, numQBoxes: 1)
            
            let enemy4 = Enemy(x: Int(self.frame.maxX) - 250, y: 0, img: "madden", typeOfEnemy: "goomba", id: 7)
            enemy4.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy4.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy4.physicsBody?.collisionBitMask = 0
            
            let platform5 : [SKNode] = makePlatform(x: Int(self.frame.minX) + 60 , y: 100, numBoxes: 4, numQBoxes: 0)
            
            let platform6 : [SKNode] = makePlatform(x: 0 , y: -100, numBoxes: 4, numQBoxes: 0)
            
            
            let now = DispatchTime.now()
            let nanoTime = now.uptimeNanoseconds - startOfLevel.uptimeNanoseconds // Difference in nano seconds
            timeInterval = Double(nanoTime) / 1_000_000_000
            if(Int(timeInterval) == 3 && intervalsUsed.contains(Int(timeInterval)) == false ){
                intervalsUsed.append(Int(timeInterval))
                enemy1.zPosition = 1
                addChild(enemy1)
                //moveEnemiesBackAndForth()
            }
            if(Int(timeInterval) == 6 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                obstacle1.zPosition = 1
                addChild(obstacle1)
               
                
            }
            if(Int(timeInterval) == 9 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(enemy1.description)
                removeEnemy()
                addChild(enemy2)
            }
            
            if(Int(timeInterval) == 12 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(obstacle1.description)
                removeObstacle()
               // platform1 = makePlatform(x: 0 , y: 0, numBoxes: 5, numQBoxes: 1)
                for node in platform1{
                    addChild(node)
                }
            }
            
            if(Int(timeInterval) == 15 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(enemy2.description)
                removeEnemy()
                addChild(obstacle2)
            }
            
            if(Int(timeInterval) == 20 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                //add enemy and 2 platforms
                //TODO: add collectible on top of platform
                for node in platform1{
                   // print("adding to not on screen list")
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                
                self.notOnScreen.append(obstacle2.description)
                removeObstacle()
                
                addChild(enemy3)
                for node in platform2{
                    addChild(node)
                }
                
                for node in platform3{
                    addChild(node)
                }
            }
            
            if(Int(timeInterval) == 25 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform2{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                addChild(obstacle3)
            }
            
            if(Int(timeInterval) == 30 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform3{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                self.notOnScreen.append(enemy3.description)
                removeEnemy()
                for node in platform4{
                    addChild(node)
                }
                
            }
            
            if(Int(timeInterval) == 35 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(obstacle3.description)
                removeObstacle()
                addChild(enemy4)
            }
            
            if(Int(timeInterval) == 40 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform4{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                for node in platform5{
                    addChild(node)
                }
                for node in platform6{
                    addChild(node)
                }
                //TODO: add collectible on top of platform 5
            }
            
            
            if(Int(timeInterval) == 45 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform5{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                self.notOnScreen.append(enemy4.description)
                removeEnemy()
                //TODO: add ending flag
            }
            
            
            if(Int(timeInterval) == 50 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform6{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                
            }
            
            
            
            
            
            
            
        
            
        
        } //end of if level  == 1
        self.score = Int(timeInterval)
        moveBackground()
        updateLabels()
    }
    
    func removeEnemy(){
        self.enumerateChildNodes(withName: "Enemy", using: ({
            (node,error) in
            if(self.notOnScreen.contains(node.description)){
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    func removeObstacle(){
        self.enumerateChildNodes(withName: "Obstacle", using: ({
            (node,error) in
            if(self.notOnScreen.contains(node.description)){
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    func removePlatform(){
        self.enumerateChildNodes(withName: "Platform", using: ({
            (node,error) in
        //    print("remove platform")
         //   print("list: " + self.notOnScreen.description)
            if(self.notOnScreen.contains(node.description)){
         //       print("removing box")
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
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

    func makePlatform(x:Int, y:Int, numBoxes:Int, numQBoxes:Int) -> [SKNode] {
        let img_width = 20
        var platformBoxes : [SKNode] = []
        for i in 0...numBoxes {
            let x_coord = x + (i*img_width)
           // print("x-coord: " + String(x_coord))
            let platBox = PlatformBox(x:x_coord,y:y,isQ:false)
            //self.addChild(platBox)
            platformBoxes.append(platBox)
        }
        let q_x_coord = x + (numBoxes*img_width)
        let questionBox = PlatformBox(x:q_x_coord,y:y,isQ:true)
        //self.addChild(questionBox)
        platformBoxes.append(questionBox)
       // print("PLATFORM BOXES: " + platformBoxes.description)
        return platformBoxes
    }
}
