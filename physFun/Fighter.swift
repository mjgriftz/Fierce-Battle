//
//  Fighter.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/8/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Fighter : SKSpriteNode {
    
    let atkpwr: Int
    let spriteAtlas: SKTextureAtlas?
    let boundingBox: BoundingBox
    static let frameDuration: Int = 10
    static let inputSensitivity: CGFloat = 0.1
    static let maxVelocityX: CGFloat = 50.0
    var opponent: Fighter?
    var jumpVelocity: CGFloat = 0.0
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    var didTouch = false
    var isWalking = false
    var currentWalkFrame = 0
    var currentAtkFrame = 0
    var currentSpecialFrame = 0
    var state: FighterState = standState()
    var nextState: FighterState? = nil
    var walkFrames = ["contact", "recoil", "pass", "high"]
    var atkFrames = ["atk1", "atk2", "atk3", "atk4"]
    var hp: Int
    
    /* Initializers */
    
    init(withAtlas atlas: SKTextureAtlas) {
        self.spriteAtlas = atlas
        self.boundingBox = BoundingBox(position: CGPoint.zero, of: CGSize(width: 100.0, height: 256.0))
        self.atkpwr = 7;
        self.hp = 100;
        super.init(texture: self.spriteAtlas!.textureNamed("stand"), color: UIColor.white, size: (self.spriteAtlas?.textureNamed("stand").size())!)
        self.boundingBox.size = self.spriteAtlas!.textureNamed("stand").size()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Methods */
    
    fileprivate func checkAnimation() {
        
        // Runs through appropriate animation frames in sequence
        
        state.runAnimation(self)
 
    }
    
    fileprivate func runPhysics(withGravity gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        
        // Defines custom physics behavior for Player object
        
        self.boundingBox.position = self.position
        self.velocityY += gravity
        self.position.y += self.velocityY
        if self.position.y < floor {
            self.position.y = floor
            self.velocityY = 0.0
        }
        if self.position.x < 0.0 { self.position.x = 0.0}
        if self.position.x > right { self.position.x = right }
    }

    
    func touchBehavior(_ first: CGPoint, next: CGPoint) {
        
        // Defines behavior for touchesMoved
        
        self.state.touchBehavior(self, first: first, next: next)
    }
    
    func endTouchBehavior() {
        
        // Defines behavior for touchesEnded
        
        self.state.endTouchBehavior(self)
        self.size = (self.texture?.size())!

    }
    
    func didHit(with box: Hitbox) -> Bool {
        if !(opponent?.boundingBox.max.x < box.min.x
            || opponent?.boundingBox.max.y < box.min.y
            || opponent?.boundingBox.min.x > box.max.x
            || opponent?.boundingBox.min.y > box.max.y) {
            return true
        }
        return false
    }
    
    func requestJump() {
        
    }
    
    func update(with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        
        // called once per frame
        
        self.boundingBox.updatePosition(self.position)
        
        if nextState != nil {
            self.state = nextState!
            self.nextState = nil 
            self.state.entryBehavior(self)
        }
        
        self.runPhysics(withGravity: gravity, floor: floor, right: right)
        self.checkAnimation()
        self.state.update(self, with: gravity, floor: floor, right: right)
 

      
    }
    
    
}
