//
//  GameScene.swift
//  Pachinko
//
//  Created by P sena on 12/04/19.
//  Copyright © 2019 Coding with Swift. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let maxBalls = 5      // Maximum number of balls allowed to be created.
    
    var scoreLabel: SKLabelNode!
    
    var tickerLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score:\(score)"
        }
    }
    
    var ballRemains = 5 {
        didSet {
            tickerLabel.text = "Ball remains:\(ballRemains)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var messageLabel: SKLabelNode!
    
    var replayLabel: SKLabelNode!
    
    var totalBalls: Int = 0 // Total number of balls the user throwed inclusive of grace/free balls.
    var numBalls: Int = 0 // Number of balls being created till a moment in single round of game.
    var boxesToRemove: [SKNode] = [SKNode]() // When a ball hit a box(es) then those are to be removed.
    var boxes: [SKNode] = [SKNode]() // All of the boxes created till a moment in single round of game.
    var numBoxes = 0 // Total number of boxes created till a moment in a single rund of game.
    var numBoxesRemovable = 0 //number of removable boxes till a moment. Keep updating during play.
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background") // create the sprite node
        background.position = CGPoint(x:512, y: 384) // POsition it in the center of the ipad where it's dimension is 1024x768
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background) // add it to our game scene
        
        // Create a score label now to show initial and farther scores to user.
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score:0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .right
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        // Create and show the replay button as well.
        replay()
        
        // Create the ticker label.
        tickerLabel = SKLabelNode(fontNamed: "Chalkduster")
        tickerLabel.text = "Balls remain:\(ballRemains)"
        tickerLabel.horizontalAlignmentMode = .right
        tickerLabel.position = CGPoint(x: 800, y: 700)
        addChild(tickerLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // add a physics body to the frame i.e; to the border lines.
        
        // Assign the current Game scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self

        // The slot should appear behind the bouncers in the scene.
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true) // this one is half way of x=256 i.e; the 256 seen below.
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        // Create lots of bouncers evenly spaced at intervals of 256 till the other edge.
        makeBuncer(at: CGPoint(x: 0, y: 0))
        makeBuncer(at: CGPoint(x: 256, y: 0))
        makeBuncer(at: CGPoint(x: 512, y: 0))
        makeBuncer(at: CGPoint(x: 768, y: 0))
        makeBuncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // We will check here whether the user clicked the Edit button or some other position in scene.
        // So based on that we proceed to normal ball creation code or edit toggle code.
        let objects = nodes(at: location) // Hey SprikeKit! give us the list of all the nodes at the point that was tapped now.
        
        // If tapped the replay label/button then restart the game.
        if objects.contains(replayLabel) {
            restartGame()
        }
        // if tapped the edit label then it would be within the objects list and then toggle the label accordingly.
        else if objects.contains(editLabel) {
            // First we need to check whether this is a replay game round. Because when one round is over
            // then "Edit" button disappears and it is expected that player click the replay button or quit
            // the game itself. So to avoid detecting here and there clicks & their actions we need to check
            // the case and return (do nothing) if it is a replay game case.
            // If we do not see the edit label then it must be asking us to replay the next round.
            // So expecting/forcing to click the replay button instead of clicking here & there.
            if editLabel.isHidden == true {
                return
            }
            // end that expectation.
            
            // Otherwise expose the function of this edit/Done label in the scene and toggle it.
            editingMode.toggle()
        } else {
            // If we do not see the edit label then it must be asking us to replay the next round.
            // So expecting/forcing to click the replay button instead of clicking here & there.
            if editLabel.isHidden == true {
                return
            }
            // end that expectation.
            
            // If we are already in editing mode anyways then create boxes to bounce off balls.
            if editingMode {
                // We add boxes to the screen of random sizes
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                numBoxes += 1
                box.name = "box \(numBoxes)" // to give the boxes name/numbered.
                print("Creating box \(String(describing: box.name))")
                
                boxes.append(box) // Keep a count of the boxes so that we can remove then when replayed game.
                
                addChild(box)
            } else { // Else create the ball via below code to let drop the ball off
                
                // We will do nothing and return if the user clicks at a point lower than the level of the score or edit labels and some more. So forcing Y position of click be above 600 only.
                if location.y < 600 {
                    return
                }
                
                if numBalls >= maxBalls {
                    let boxRemaining = boxes.count - numBoxesRemovable
                    var msg1 = ""
                    var msg2 = ""
                    if numBalls == 1 {
                        msg1 = "\(totalBalls) ball dropped"
                    } else {
                        msg1 = "\(totalBalls) balls dropped"
                    }
                    if boxRemaining == 0 {
                        msg2 = "and no boxes. You Won this round!"
                    }
                    else if boxRemaining == 1 {
                        msg2 = "\(boxRemaining) box remain from \(boxes.count). Defeated!"
                    } else {
                        msg2 = "\(boxRemaining) boxes remain from \(boxes.count). Defeated!"
                    }
                    let finishMessage = "\(msg1) \(msg2)"
                    show(message: finishMessage)
                    disableEdit()
                    return
                }
                
                
                // Will create a random number to pick the ball's colour each time.
                let ballColours: [String] = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow", ]
                let indexBallColour = Int.random(in: 0...6)
                let ballColour = ballColours[indexBallColour]
                
                let ball = SKSpriteNode(imageNamed: ballColour)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                // The only change required for us to detect collisions is below line
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.physicsBody?.restitution = 0.4
                ball.position = location
                ball.name = "ball"
                addChild(ball)
                numBalls += 1
                totalBalls += 1
            }
        }
    }
    
    func disableEdit() {
        editLabel.isHidden = true
    }
    
    func restartGame() {
        score = 0
        numBoxes = 0
        numBalls = 0
        totalBalls = 0
        numBoxesRemovable = 0
        ballRemains = maxBalls
        
        if editingMode {
            editingMode.toggle()
        }
        if ((messageLabel?.text) != nil) {
            messageLabel.removeFromParent()
        }
        for box in boxes {
            box.removeFromParent()
        }
        boxes.removeAll()
        if editLabel.isHidden {
            editLabel.isHidden = false
        }
    }
    
    func replay() {
        replayLabel = SKLabelNode(fontNamed: "Chalkduster")
        replayLabel.text = "Replay"
        replayLabel.horizontalAlignmentMode = .left
        replayLabel.position = CGPoint(x:256, y: 700)
        addChild(replayLabel)
    }
    
    func show(message: String) {
        messageLabel = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel.text = message
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.position = CGPoint(x: 512, y: 500)
        addChild(messageLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered.
    }
    
    func makeBuncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    // This is called when the ball collides with something else.
    // This is the contact checking method.
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            // If the collision is between a ball and a good slot (Green)
            score += 1
            
            // Give an extra ball whenever a ball falls on a good slot.
            print("Ball falls on good slot, number of balls falled : \(numBalls)")
            if numBalls > 0 {
                numBalls -= 1
                ballRemains = maxBalls - numBalls
                print("Got a free ball. No. of balls now remains : \(ballRemains)")
            }
        } else if object.name == "bad" {
            destroy(ball: ball)
            // If the collision is between a ball and a bad slot (Red)
            score -= 1
            
            ballRemains = maxBalls - numBalls // Just to keep tickering the ticker along with.
            
            print("Ball falls on bad slot, number of balls falled : \(numBalls)")
            print("No. of balls now remains : \(ballRemains)")
        } else if object.name?.hasPrefix("box") ?? false {
            // Gather the box hit by the ball to get it removed after a moment.
            // BUt ensure that a same box is gathered only once even though it has been hit more than once
            // by two different balls or same ball.
            if !boxesToRemove.contains(object) {
                boxesToRemove.append(object)
                //First store count of boxes collected till that moment. This is the immediate previous count always.
                numBoxesRemovable += 1
            }
        }
        
        // Destroy the box hit by the ball a moment back along with it's own destroy'ness.
        destroyBox()
    }
    
    func destroyBox() {
        for box in boxesToRemove {
            box.removeFromParent()
        }
        boxesToRemove.removeAll()
    }
    
    // This is called when we are finished with the ball and want to get rid of it.
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    // This is called by SpriteKit whenever two nodes in scene come in physical contact to each other.
    // So this is the contact detection method in built.
    func didBegin(_ contact: SKPhysicsContact) {
        // If the nodes/balls are already removed from a prior collision then return because we cannot force unwrap a non existing ball.
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
