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
    let HEALTH_SIZE: CGFloat = 500.0
    let P_LAYER: CGFloat = 6.0
    let HUD_LAYER: CGFloat = 10.0
    let startPosition1 = CGPoint(x: 300.0, y: 500.0);
    let startPosition2 = CGPoint(x: 1000.0, y: 500.0)
    let Player1 = Fighter(withAtlas: SKTextureAtlas(named: "Kermit"))
    let Player2 = Fighter(withAtlas: SKTextureAtlas(named: "Kermit"))
    let joyBase = SKSpriteNode(texture: SKTextureAtlas(named: "Joystick").textureNamed("stickBase"))
    let joyStick = SKSpriteNode(texture: SKTextureAtlas(named: "Joystick").textureNamed("joyStick"))
    let buttonList: [GameButton] = [
        BlockButton(withImage: "blockButton", atPosition: CGPoint(x: 1536, y: 512)),
        JumpButton(withImage: "jumpButton", atPosition: CGPoint(x: 1728, y: 704)),
        SpecialButton(withImage: "specialButton", atPosition: CGPoint(x: 1728, y: 320)),
        AttackButton(withImage: "attackButton", atPosition: CGPoint(x: 1920, y: 512))
    ]
    var stage = Stage(stageImage: "GuileBG")
    var healthBar1 = SKSpriteNode(imageNamed: "healthBar")
    var healthBar2 = SKSpriteNode(imageNamed: "healthBar")
    var audio: AVAudioPlayer?
    var firstTouch: CGPoint?
    var joyDidInit: Bool = false

    
    override func didMove(to view: SKView) {

        // Configure and assign audio player
        
        do { try self.audio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "DangerZone", ofType: "mp3")!))
        } catch {
        
        }
        
        self.audio?.prepareToPlay()
        self.audio?.play()
        
        // Configure and draw Stage
        
        self.stage.background.size = self.size
        self.stage.background.anchorPoint = CGPoint.zero
        self.stage.background.position = CGPoint(x: 0.0, y: 200)
        self.stage.background.zPosition = 0
        self.stage.background.size.height *= 1.4
        self.stage.background.size.width *= 1.4
        self.addChild(stage.background)
        
        //Configure and draw HUD
        
        for button in buttonList {
            button.image.zPosition = self.HUD_LAYER
            self.addChild(button.image)
        }
        
        //Draw healthBar1
        
        healthBar1.position = CGPoint(x: self.size.width * (0.25), y: self.size.height * (0.75))
        healthBar1.zPosition = HUD_LAYER
        self.addChild(healthBar1)
        
        //Draw healthBar2
        
        healthBar2.position = CGPoint(x: self.size.width * (0.75), y: self.size.height * (0.75))
        healthBar2.zPosition = HUD_LAYER
        self.addChild(healthBar2)
        
        // Draw player one to the scene
        
        self.Player1.size = (self.Player1.texture?.size())!
        self.Player1.position = self.startPosition1
        self.Player1.zPosition = self.P_LAYER
        self.Player1.opponent = self.Player2
        self.addChild(self.Player1)
        
        // Draw player two to the scene
        
        self.Player2.size = (self.Player2.texture?.size())!
        self.Player2.position = self.startPosition2
        self.Player2.zPosition = self.P_LAYER
        self.Player2.opponent = self.Player1
        self.addChild(self.Player2)
        
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        var anyButtonTouched = false
        for touch in touches {
            
            // Check if touch is a button
            
            for button in self.buttonList {
                if button.wasPressed(touch.location(in: self)) { button.execute(Player1); anyButtonTouched = true}
            }
            
            // If touch isn't a button, run joystick logic
            
            if touch.location(in: self).x < (2048 * 0.75) {
                if !anyButtonTouched {
                    self.firstTouch = touches.first!.location(in: self)
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
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextTouch = touches.first!.location(in: self)
        if nextTouch.x < (2048 * 0.75){
            self.joyStick.position = nextTouch
            if let firstTouch = self.firstTouch {
                
                // insert touchBehavior here
                
                Player1.touchBehavior(firstTouch, next: nextTouch)
            }
        }
  
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        var anyButtonTouched = false
        for touch in touches {
 
            for button in self.buttonList {
                if button.wasPressed(touch.location(in: self)) {anyButtonTouched = true}
            }
            if !anyButtonTouched {
                self.joyBase.removeFromParent()
                self.joyStick.removeFromParent()
                self.joyDidInit = false
                Player1.endTouchBehavior()
            }
        }
    }


    override func update(_ currentTime: TimeInterval) {
        
        /* Called before each frame is rendered */
        
        Player1.update(with: self.stage.grav, floor: self.stage.floor, right: self.stage.rightBound)
        Player2.update(with: self.stage.grav, floor: self.stage.floor, right: self.stage.rightBound)
        healthBar1.size.width = HEALTH_SIZE * (CGFloat(Player1.hp) / 100.0)
        healthBar2.size.width = HEALTH_SIZE * (CGFloat(Player2.hp) / 100.0)
    }
}
