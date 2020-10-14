//
//  SingletonMGR.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-24.
//  Copyright © 2020 tiff. All rights reserved.
//

import Foundation
import SpriteKit
class SingletonMGR{
    
    //Initiate screen types across app
    enum SceneType{
        case StartScene,GamePlayScene,WinScene,LoseScene
    }
    
    private init() {}
    static let shared = SingletonMGR()
    
    public func launch(){
        firstLaunch()
    }
    
    //Save launch settings
    private func firstLaunch(){
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch"){
            print("This is our first launch")
            SingletonMusic.shared.setSounds(true)
            SingletonMusic.shared.playStopBackgroundMusic()
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            UserDefaults.standard.synchronize()
        }
    }
    
    //Add transition settings and customization
    func transition(_fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil){
        guard let scene = getScene(toScene) else {return}
        if let transition = transition{
            scene.scaleMode = .resizeFill
            _fromScene.view?.presentScene(scene, transition: transition)
        }else{
            scene.scaleMode = .resizeFill
            _fromScene.view?.presentScene(scene)
        }
        
    }
    
    //Add transition settings and customization givenn all scenes in the application
    func getScene(_ sceneType: SceneType) -> SKScene?{
        switch sceneType {
        case SceneType.StartScene:
            return StartScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.GamePlayScene:
            return GamePlayScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.WinScene:
            return WinScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.LoseScene:
            return LoseScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        }
        
    }
    
    
    func run(_ fileName: String, onNode: SKNode){
        if SingletonMusic.shared.getSound(){
            onNode.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
        }
    }
    
    
}
