//
//  SingletonMusic.swift
//  chan1540_a5
//
//  Created by tiff on 2020-03-24.
//  Copyright © 2020 tiff. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

let SoundState = "kSoundState"
class SingletonMusic{
    
    private init(){}
    static let shared = SingletonMusic()
    
    //Create AV audioplayer and loop
    lazy var backGroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "No Monkey", withExtension: "wav") else{
            return nil
        }
        do{
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        }catch{
            return nil
        }
    }()
    
    //Remember Settings
    func setSounds(_ state: Bool){
        UserDefaults.standard.set(state, forKey: SoundState)
        UserDefaults.standard.synchronize()
    }
    
    func getSound() -> Bool{
        return UserDefaults.standard.bool(forKey: SoundState)
    }
    
    //Play Stop function
    func playStopBackgroundMusic(){
    if SingletonMusic.shared.getSound(){
        backGroundMusic?.play()
    }else{
        backGroundMusic?.stop()
        }}
}
