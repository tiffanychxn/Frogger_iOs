//
//  GamePlayScene.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-24.
//  Copyright © 2020 tiff. All rights reserved.
//

import Foundation
import SpriteKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate  {
    
    //MARK: Initiate Variables
    var frog: SKSpriteNode?
    var upButton: SKSpriteNode?
    var downButton: SKSpriteNode?
    var leftButton: SKSpriteNode?
    var rightButton: SKSpriteNode?
    var playerPoint: CGPoint?
    var winningFloat: CGFloat?
    let frogJump = SKAction.playSoundFileNamed("mlem.mp3", waitForCompletion: false)
    let carSound = SKAction.playSoundFileNamed("carSound.mp3", waitForCompletion: false)
    let splatSound = SKAction.playSoundFileNamed("splatEffect.mp3", waitForCompletion: false)
    let car_speed = CGFloat(50)

    //MARK: Initiate Physics Hex
    struct PhysicsCategory{
        static let None : UInt32 = 0
        static let All : UInt32 = UInt32.max
        static let Frog : UInt32 = 0b1
        static let Car : UInt32 = 0b10
    }
    
    //MARK: Initiate Screen Parameters
    override init(size: CGSize){
        super.init(size: size)
        backgroundColor = SKColor.white
        //set all gameplay sprites
        setNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Car Spawning
    override func didMove(to view: SKView){
        
        //set create functions to spawn cars in all rows
        let wait = SKAction.wait(forDuration: 1, withRange: 4)
        let spawn = SKAction.run({[unowned self] in
            self.spawnCar(carRow: 0)
            self.run(self.carSound)
        })
        let spawn2 = SKAction.run({[unowned self] in
            self.spawnCar(carRow: 1)
            self.run(self.carSound)
        })
        let spawn3 = SKAction.run({[unowned self] in
            self.spawnCar(carRow: 2)
            self.run(self.carSound)
        })
        let spawn4 = SKAction.run({[unowned self] in
            self.spawnCar(carRow: 3)
            self.run(self.carSound)
        })
        
        //start infinite spwaning loop
        let sequence = SKAction.sequence([wait, spawn, wait, spawn2, wait, spawn3, wait, spawn4])
        let loop = SKAction.repeatForever(sequence)
        run(loop , withKey:"spawning")
        }
    
    //MARK: Start Gameplay Sprites
    func setNodes(){
        //set scaled parameters
        let screenWidth = self.frame.width
        let buttonWidth = screenWidth/4.0
        let playWidth = screenWidth/6.0
        
        //set physics delegate
        physicsWorld.gravity = CGVector(dx: 0, dy:0)
        physicsWorld.contactDelegate = self
        
        //initiate play buttons
        leftButton = SKSpriteNode(imageNamed: "left-arrow")
        leftButton!.name="lb"
        leftButton!.size = CGSize(width: buttonWidth, height: buttonWidth)
        leftButton!.position = CGPoint(x: self.frame.minX + leftButton!.frame.maxX,y: self.frame.minY + leftButton!.frame.maxY)
        self.addChild(leftButton!)
        
        downButton = SKSpriteNode(imageNamed: "down-arrow")
        downButton!.name = "db"
        downButton!.size = CGSize(width: buttonWidth, height: buttonWidth)
        downButton!.position = CGPoint(x: leftButton!.frame.maxX + downButton!.frame.maxY,y: self.frame.minY+downButton!.frame.maxY)
        self.addChild(downButton!)
        
        upButton = SKSpriteNode(imageNamed: "up-arrow")
        upButton!.name="ub"
        upButton!.size = CGSize(width: buttonWidth, height: buttonWidth)
        upButton!.position = CGPoint(x: downButton!.frame.maxX + upButton!.frame.maxX,y: self.frame.minY+upButton!.frame.maxY)
        self.addChild(upButton!)
        
        rightButton = SKSpriteNode(imageNamed: "right-arrow")
        rightButton!.name="rb"
        rightButton!.size = CGSize(width: buttonWidth, height: buttonWidth)
        rightButton!.position = CGPoint(x: self.frame.maxX - rightButton!.frame.maxX,y: self.frame.minY + rightButton!.frame.maxY)
        self.addChild(rightButton!)
        
        //initiate sidewalk
        let sidewalk1 = SKShapeNode(rectOf: CGSize(width: self.scene!.frame.width, height: playWidth))
        sidewalk1.fillColor = SKColor.gray
        sidewalk1.position = CGPoint(x: self.frame.minX + sidewalk1.frame.maxX,y: rightButton!.frame.maxY + sidewalk1.frame.maxY)
        self.addChild(sidewalk1)
        
        let sidewalk2 = SKShapeNode(rectOf: CGSize(width: self.scene!.frame.width, height: playWidth))
        sidewalk2.fillColor = SKColor.gray
        sidewalk2.position = CGPoint(x: self.frame.minX + sidewalk2.frame.maxX,y: self.frame.minY + playWidth*7)
        winningFloat = self.frame.minY + playWidth*7
        self.addChild(sidewalk2)
        
        
        //initiate frog player
        frog = SKSpriteNode(imageNamed: "froggy.png")
        frog!.size = CGSize(width: playWidth, height: playWidth)
        frog!.name = "frogPlayer"
        frog!.position = CGPoint(x: self.frame.minX + frog!.frame.maxX*4,y: rightButton!.frame.maxY + frog!.frame.maxY)
        
        //initiate frog physics rules
        frog!.physicsBody = SKPhysicsBody(circleOfRadius: playWidth/3)
        frog!.physicsBody?.isDynamic = true
        frog!.physicsBody?.categoryBitMask = PhysicsCategory.Frog
        frog!.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        frog!.physicsBody?.collisionBitMask = PhysicsCategory.None
        frog!.physicsBody?.usesPreciseCollisionDetection = true
 
        
        self.addChild(frog!)
        
        playerPoint = frog!.position
    
    }
    
    //MARK: Rect to player commands, keep frogs within bounds
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let incr = self.frame.width/6.0
            let location = touch.location(in:self)
            let theNode = self.atPoint(location)
            
            //move frog given player touches left button
            if theNode.name == leftButton!.name{
                if playerPoint!.x > (self.frame.minX + incr){
                    playerPoint!.x = playerPoint!.x - incr
                    moveFrog()
                }
            }
            
            //move frog given player touches right button
            if theNode.name == rightButton!.name{
                if playerPoint!.x < (self.frame.maxX - incr){
                    playerPoint!.x = playerPoint!.x + incr
                    moveFrog()
                }
            }
            
            //move frog given player touches up button
            if theNode.name == upButton!.name{
                playerPoint!.y = playerPoint!.y + incr
                moveFrog()
            }
            
            //move frog given player touches down button
            if theNode.name == downButton!.name{
                if playerPoint!.y > (self.frame.minY + self.frame.width/3){
                    playerPoint!.y = playerPoint!.y - incr
                    moveFrog()
                }
            }
            
            //move to win screen if sidewalk is touched
            if self.playerPoint!.y == self.frame.minY + (self.frame.width/6.0)*7{
                SingletonMGR.shared.transition(_fromScene: self, toScene: .WinScene, transition: SKTransition.moveIn(with: .right, duration: 1.5))
            }
        }
    }
    
    //MARK: Spawn Car Function
    private func spawnCar(carRow: Int){
        var carPoint: CGPoint?
        var car: SKSpriteNode?
        let incr = self.frame.width/6.0
        var moveCar: CGFloat?
        moveCar = 2 * car_speed
        
        //Set parameters given car row
        switch carRow {
        case 0:
            car = SKSpriteNode(imageNamed: "car1.png")
            car!.size = CGSize(width: incr, height: incr)
            carPoint = CGPoint(x: self.frame.minX,y: rightButton!.frame.maxY + car!.frame.maxY*3)
        case 1:
            moveCar = -moveCar!
            car = SKSpriteNode(imageNamed: "car2.png")
            car!.size = CGSize(width: incr, height: incr)
            carPoint = CGPoint(x: self.frame.maxX,y: rightButton!.frame.maxY + car!.frame.maxY*5)
        case 2:
            car = SKSpriteNode(imageNamed: "car1.png")
            car!.size = CGSize(width: incr, height: incr)
            carPoint = CGPoint(x: self.frame.minX,y: rightButton!.frame.maxY + car!.frame.maxY*7)
        case 3:
            moveCar =  -moveCar!
            car = SKSpriteNode(imageNamed: "car2.png")
            car!.size = CGSize(width: incr, height: incr)
            carPoint = CGPoint(x: self.frame.maxX,y: rightButton!.frame.maxY + car!.frame.maxY*9)
        
        default:
            print("no car spawned")
        }
        
        //Set physics rules
        car!.physicsBody = SKPhysicsBody(circleOfRadius: incr/3)
        car!.physicsBody?.isDynamic = true
        car!.physicsBody?.categoryBitMask = PhysicsCategory.Car
        car!.physicsBody?.contactTestBitMask = PhysicsCategory.Frog
        car!.physicsBody?.collisionBitMask = PhysicsCategory.None
        car!.physicsBody?.usesPreciseCollisionDetection = true
        
        car!.name = "Car"
        car!.position = carPoint!
        self.addChild(car!)
        
        //increment car movements
        while (carPoint!.x <= self.frame.maxX + incr*2) && (carPoint!.x > self.frame.minX - incr*2){
            carPoint!.x = carPoint!.x + moveCar!
            car!.run(SKAction.move(to: CGPoint(x: carPoint!.x, y: carPoint!.y), duration: 5))
            
        }
        
    }
    
    //MARK: Frog navigation
    private func moveFrog(){
        frog?.run(SKAction.move(to: CGPoint(x: playerPoint!.x, y: playerPoint!.y), duration: 0))
        run(self.frogJump)
    }
    
    
    //Mark: Collision detection
    func didBegin(_ contact: SKPhysicsContact){
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Frog | PhysicsCategory.Car{
            
            
            //replace frog with splat image
            let splat = SKSpriteNode(imageNamed: "splat")
            splat.size = CGSize(width: self.frame.width/6.0, height: self.frame.width/6.0)
            splat.position = self.frog!.position
            self.run(self.splatSound)
            self.addChild(splat)
            for child in self.children{
                if child.name == "frogPlayer"{
                    child.removeFromParent()
                }
            }
            
            //Move to Lose Scene
            SingletonMGR.shared.transition(_fromScene: self, toScene: .LoseScene, transition: SKTransition.moveIn(with: .right, duration: 1.5))
            
        }
        
    }
    
    
    
    
}

