//
//  TitleScene.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/2/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class TitleScene: SKScene {

    var audio: AVAudioPlayer?
    
    
    override func didMove(to view: SKView) {
        
        do { try self.audio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "NWO", ofType: "mp3")!))
        } catch {
            
        }
        
        self.audio?.prepareToPlay()
        self.audio?.play()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
        
        let touching = touches.first
        let theScene = GameScene(fileNamed: "GameScene")
        let sceneSize = CGSize(width: 2048, height: 1536)
        theScene?.size = sceneSize
        self.audio?.stop()
        let trans = SKTransition.doorsCloseHorizontal(withDuration: 1)
        theScene?.scaleMode = .aspectFill
        self.view?.presentScene(theScene!, transition: trans)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //
    }
}

