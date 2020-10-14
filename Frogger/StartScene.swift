//
//  StartScene.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-23.
//  Copyright © 2020 tiff. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    var backgroundSound: SKAudioNode!
    var playGame: SKSpriteNode?
    var playGameText: SKLabelNode?
    var playMusic: SKLabelNode?
    var stopMusic: SKLabelNode?
    
    override init(size: CGSize){
        
        super.init(size: size)
        backgroundColor = SKColor.white
        
        //Initialize Start Screen Sprites
        playGame = SKSpriteNode(imageNamed: "froggy.png")
        playGame!.name="playGame"
        playGame!.position=CGPoint(x:self.frame.midX, y:self.frame.midY + 100);
        self.addChild(playGame!)

        
        playGameText = SKLabelNode(fontNamed: "Arial")
        playGameText!.fontSize = 40
        playGameText!.fontColor = SKColor.black
        playGameText!.text = "PLAY"
        playGameText!.name="playGameText"
        playGameText!.position=CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(playGameText!)
        
        
        playMusic = SKLabelNode(fontNamed: "Arial")
        playMusic!.fontSize = 20
        playMusic!.fontColor = SKColor.black
        playMusic!.text = "PLAY MUSIC"
        playMusic!.name="playMusic"
        playMusic!.position=CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        self.addChild(playMusic!)
        
        stopMusic = SKLabelNode(fontNamed: "Arial")
        stopMusic!.fontSize = 20
        stopMusic!.fontColor = SKColor.black
        stopMusic!.text = "STOP MUSIC"
        stopMusic!.name="stopMusic"
        stopMusic!.position=CGPoint(x:self.frame.midX, y:self.frame.midY-200);
        self.addChild(stopMusic!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Button React
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in:self)
            let theNode = self.atPoint(location)
            
            //instruct application based on used choosing
            if (theNode.name == playGame!.name) || (theNode.name == playGameText!.name){
                SingletonMGR.shared.transition(_fromScene: self, toScene: .GamePlayScene)
            }
            if theNode.name == playMusic!.name{
                SingletonMusic.shared.setSounds(true)
                SingletonMusic.shared.playStopBackgroundMusic()
                
            }
            if theNode.name == stopMusic!.name{
                SingletonMusic.shared.setSounds(false)
                SingletonMusic.shared.playStopBackgroundMusic()
                
            }
        }
    }
    
    
    
 
}
