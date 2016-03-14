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
    
    
    override func didMoveToView(view: SKView) {
        
        do { try self.audio = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("NWO", ofType: "mp3")!))
        } catch {
            
        }
        
        self.audio?.prepareToPlay()
        self.audio?.play()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //
        
        
        let touching = touches.first
        let theScene = GameScene(fileNamed: "GameScene")
        let sceneSize = CGSize(width: 2048, height: 1536)
        theScene?.size = sceneSize
        self.audio?.stop()
        let trans = SKTransition.doorsCloseHorizontalWithDuration(1)
        theScene?.scaleMode = .AspectFill
        self.view?.presentScene(theScene!, transition: trans)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        //
    }
}

