//
//  WinScene.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-25.
//  Copyright © 2020 tiff. All rights reserved.
//

import Foundation
import SpriteKit

class WinScene: SKScene{
    var timer = Timer()
    override init(size: CGSize){
        
        //Initialize Text Sprites
        super.init(size: size)
        backgroundColor = SKColor.gray
        let label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.text = "CONGRATS! YOU WIN"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Arial")
        label2.fontSize = 20
        label2.fontColor = SKColor.black
        label2.text = "Going back to menu."
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        self.addChild(label2)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        //Create a Scheduled timer thats will fire a function after the timeInterval
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(presentNewScene),
                                     userInfo: nil, repeats: false)
    }

    @objc func presentNewScene() {
        //Configure the new scene to be presented and then present.
        SingletonMGR.shared.transition(_fromScene: self, toScene: .StartScene)
    }

    deinit {
        //Stops the timer.
        timer.invalidate()
    }
    
}
