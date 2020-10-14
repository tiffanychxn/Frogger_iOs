//
//  GameViewController.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-23.
//  Copyright © 2020 tiff. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //Load Start Scene
        let scene = StartScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    
}
