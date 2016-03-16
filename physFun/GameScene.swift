//
//  GameScene.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/2/16.
//  Copyright (c) 2016 Griffy. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    let buttonList: [GameButton] = [
        BlockButton(withImage: "blockButton", atPosition: CGPoint(x: 1536, y: 512)),
        JumpButton(withImage: "jumpButton", atPosition: CGPoint(x: 1728, y: 704)),
        SpecialButton(withImage: "specialButton", atPosition: CGPoint(x: 1728, y: 320)),
        AttackButton(withImage: "attackButton", atPosition: CGPoint(x: 1920, y: 512))
        ]
    let Player1 = Fighter(withAtlas: SKTextureAtlas(named: "Kermit"))
    let Player2 = Fighter(withAtlas: SKTextureAtlas(named: "Kermit"))
    var stage = Stage(stageImage: "GuileBG")
    var audio: AVAudioPlayer?
    var firstTouch: CGPoint?
    var joyDidInit: Bool = false
    let joyBase = SKSpriteNode(texture: SKTextureAtlas(named: "Joystick").textureNamed("stickBase"))
    let joyStick = SKSpriteNode(texture: SKTextureAtlas(named: "Joystick").textureNamed("joyStick"))
    
    override func didMoveToView(view: SKView) {

        // Configure and assign audio player
        do { try self.audio = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GuileTheme", ofType: "mp3")!))
        } catch {
        
        }
        
        self.audio?.prepareToPlay()
        self.audio?.play()
        
        // Configure and draw Stage
        self.stage.background.size = self.size
        self.stage.background.anchorPoint = CGPointZero
        self.stage.background.position = CGPoint(x: 0.0, y: 200)
        self.stage.background.zPosition = 0
        self.stage.background.size.height *= 1.4
        self.stage.background.size.width *= 1.4
        self.addChild(stage.background)
        
        //Configure and draw HUD
        for button in buttonList {
            button.image.size.width *= 2
            button.image.size.height *= 2
            button.image.zPosition = 20
            self.addChild(button.image)
        }
       
        
        
        // Draw player one to the scene
        self.Player1.size = (self.Player1.texture?.size())!
        self.Player1.position = CGPoint(x: 300.0, y: 500.0)
        self.Player1.zPosition = 6
        self.addChild(self.Player1)
        
        // Draw player two to the scene
        self.Player2.size = (self.Player2.texture?.size())!
        self.Player2.position = CGPoint(x: 550.0, y: 500.0)
        self.Player2.zPosition = 6
        self.addChild(self.Player2)
        
    }
    
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        var anyButtonTouched = false
        for touch in touches {
                // check if touch is a button
            for button in self.buttonList {
                if button.wasPressed(touch.locationInNode(self)) { button.execute(Player1); anyButtonTouched = true}
            }
            
                //if touch isn't a button, run joystick logic
            if !anyButtonTouched {
                self.firstTouch = touches.first!.locationInNode(self)
                self.joyBase.position = self.firstTouch!
                self.joyBase.zPosition = 20
                self.joyStick.position = self.firstTouch!
                self.joyStick.zPosition = 21
                if !joyDidInit {
                    self.addChild(self.joyBase)
                    self.addChild(self.joyStick)
                }
                self.joyDidInit = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let nextTouch = touches.first!.locationInNode(self)
  
            self.joyStick.position = nextTouch
            if let firstTouch = self.firstTouch {
            // insert touchBehavior here
                Player1.touchBehavior(firstTouch, next: nextTouch)
            }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
        var anyButtonTouched = false
        for touch in touches {
 
            for button in self.buttonList {
                if button.wasPressed(touch.locationInNode(self)) {anyButtonTouched = true}
            }
            if !anyButtonTouched {
                self.joyBase.removeFromParent()
                self.joyStick.removeFromParent()
                self.joyDidInit = false
                Player1.endTouchBehavior()
            }
        }
    }


    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        Player1.update(with: self.stage.grav, floor: self.stage.floor, right: self.stage.rightBound)
        Player2.update(with: self.stage.grav, floor: self.stage.floor, right: self.stage.rightBound)
    }
}
