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
    var viewCtrl: UIViewController?
    
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
        self.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue //ground acts as a obstacle
        
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
        mainChar.physicsBody?.contactTestBitMask = collisionTypes.enemy.rawValue | collisionTypes.power.rawValue | collisionTypes.collectible.rawValue | collisionTypes.obstacle.rawValue | collisionTypes.platform.rawValue
        //what do we not want to walk through
        mainChar.physicsBody?.collisionBitMask = collisionTypes.obstacle.rawValue | collisionTypes.platform.rawValue | collisionTypes.enemy.rawValue
        
        self.livesHelper = mainChar.lives
        addChild(mainChar)
        createBackground()
        setUpLabels()
    }
    
    func didBegin(_ contact: SKPhysicsContact) { //called when beginning of a collision is detected
        print("collisions")
        guard let nodeA = contact.bodyA.node else {
            print("hi")
            return }
        guard let nodeB = contact.bodyB.node else {
            print("hello")
            return }
        print("hreee")
        if nodeA.name == "mainChar" {
            print("h")
            playerCollided(with: nodeB)
        } else if nodeB.name == "mainChar" {
            print("y")
            playerCollided(with: nodeA)
        }
        else{
            
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
        else if node.name == "flag"{
            self.view?.isPaused = true
            self.viewCtrl?.performSegue(withIdentifier: "gameToWin", sender: self)
        }
        else if node.name == "Obstacle"{
            let mc = (self.childNode(withName: "mainChar") as! Character)
            if(mc.position.y > node.position.y){
                //if on top
                (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
            }
        }
        else if node.name == "Platform"{
            let mc = (self.childNode(withName: "mainChar") as! Character)
            if(mc.position.y > node.position.y){
                //if on top
                (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
            }
        }
        else{
            //collide with ground
            (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
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
            //declare all enemies/obstacles
            let enemy1 = Enemy(x: Int(self.frame.maxY) - 450 , y: (Int(self.frame.minX) / 4) - 30 , img: "steven", typeOfEnemy: "goomba", id: 1)
            enemy1.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy1.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            
            let obstacle1 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 2)
            obstacle1.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
            
            let enemy2 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "madden", typeOfEnemy: "goomba", id: 3)
            enemy2.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy2.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            
            let platform1 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 5, numQBoxes: 1)
            for box in platform1{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let obstacle2 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "chair", typeOfObstacles: "idk?", id: 4)
            obstacle2.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue

            let enemy3 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "steven", typeOfEnemy: "goomba", id: 5)
            enemy3.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy3.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy3.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            
            let platform2 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 5, numQBoxes: 0)  //come out before 3
            for box in platform2{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let platform3 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: Int(self.frame.maxX / 2) - 100, numBoxes: 5, numQBoxes: 1)
            for box in platform3{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let collectible1 = Collectable(x: Int(self.frame.maxY) - 105, y: Int(self.frame.maxX / 2) - 100 + 25, img: "stackOverflowLogo")
            collectible1.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
            collectible1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            collectible1.physicsBody?.collisionBitMask = 0
            
            let obstacle3 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 6)
            obstacle3.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue

            
            let platform4 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 3, numQBoxes: 1)
            for box in platform4{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let enemy4 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "madden", typeOfEnemy: "goomba", id: 7)
            enemy4.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
            enemy4.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            enemy4.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            
            let platform5 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: Int(self.frame.maxX / 2) - 100, numBoxes: 4, numQBoxes: 0) //come out ebfore 6
            for box in platform5{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let platform6 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: 0, numBoxes: 4, numQBoxes: 0)
            for box in platform6{
                box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
                box.physicsBody?.contactTestBitMask = 0
                box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            }
            
            let collectible2 = Collectable(x: Int(self.frame.maxY) - 255, y: Int(self.frame.maxX / 2) - 100 + 25, img: "stackOverflowLogo")
            collectible2.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
            collectible2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            collectible2.physicsBody?.collisionBitMask = 0
            
            
            let endFlag = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "endFlag", typeOfObstacles: "idk?", id: 8)
            endFlag.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
            endFlag.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
            endFlag.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            
            endFlag.name = "flag"
            endFlag.size.width = 300
            endFlag.size.height = self.frame.maxY / 4
            //todo:
            //add collectibles
            
            let now = DispatchTime.now()
            let nanoTime = now.uptimeNanoseconds - startOfLevel.uptimeNanoseconds // Difference in nano seconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            if(Int(timeInterval) == 1 && intervalsUsed.contains(Int(timeInterval)) == false ){
                intervalsUsed.append(Int(timeInterval))
                enemy1.zPosition = 1
                addChild(enemy1)
                //self.nodesToMove.append(enemy1.debugDescription)
        
                //moveEnemiesBackAndForth()
            }
            if(Int(timeInterval) == 10 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                obstacle1.zPosition = 1
                addChild(obstacle1)
               
                
            }
            if(Int(timeInterval) == 17 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(enemy1.description)
                removeEnemy()
                addChild(enemy2)
            }
            
            if(Int(timeInterval) == 24 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(obstacle1.description)
                removeObstacle()
               // platform1 = makePlatform(x: 0 , y: 0, numBoxes: 5, numQBoxes: 1)
                for node in platform1{
                    addChild(node)
                }
                
            }
            
            if(Int(timeInterval) == 31 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(enemy2.description)
                removeEnemy()
                addChild(obstacle2)
            }
            
            if(Int(timeInterval) == 38 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                //add enemy and 2 platforms
                for node in platform1{
                    print("adding to not on screen list")
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
                addChild(collectible1)
            }
            
            if(Int(timeInterval) == 45 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform2{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                addChild(obstacle3)
            }
            
            if(Int(timeInterval) == 52 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform3{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                self.notOnScreen.append(collectible1.description)
                removeCollectable()
                self.notOnScreen.append(enemy3.description)
                removeEnemy()
                for node in platform4{
                    addChild(node)
                }
                
            }
            
            if(Int(timeInterval) == 59 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                self.notOnScreen.append(obstacle3.description)
                removeObstacle()
                addChild(enemy4)
            }
            
            if(Int(timeInterval) == 66 && intervalsUsed.contains(Int(timeInterval)) == false){
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
                addChild(collectible2)
                //TODO: add collectible on top of platform 5
            }
            
            
            if(Int(timeInterval) == 72 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform5{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                self.notOnScreen.append(enemy4.description)
                removeEnemy()
                self.notOnScreen.append(collectible2.description)
                removeCollectable()
                //TODO: add ending flag
            }
            
            
            if(Int(timeInterval) == 79 && intervalsUsed.contains(Int(timeInterval)) == false){
                intervalsUsed.append(Int(timeInterval))
                for node in platform6{
                    self.notOnScreen.append(node.description)
                }
                removePlatform()
                //add flag
                addChild(endFlag)
                
            }
            
            
            
            
            //when show end of level: self.notOnScreen.removeAll()
            
            
        } //end of if level  == 1
        self.score = Int(timeInterval)
        moveBackground()
        moveNodesWithBackground()
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
    
    func removeCollectable(){
        self.enumerateChildNodes(withName: "collectible", using: ({
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
    
    func moveNodesWithBackground(){
        self.enumerateChildNodes(withName: "Enemy", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "Obstacle", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "Platform", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "collectible", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "flag", using: ({
            (node,error) in
            node.position.x -= 1
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
