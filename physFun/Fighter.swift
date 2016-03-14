//
//  Fighter.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/8/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import SpriteKit

class Fighter : SKSpriteNode {
    
    let spriteAtlas: SKTextureAtlas?
    let boundingBox: BoundingBox
    static let frameDuration: Int = 10
    static let inputSensitivity: CGFloat = 0.1
    static let maxVelocityX: CGFloat = 50.0
    var jumpVelocity: CGFloat = 0.0
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    var didTouch = false
    var isWalking = false
    var currentFrame = 0
    var state: FighterState = standState()
    var nextState: FighterState? = nil
    var frames = ["contact", "recoil", "pass", "high"] 
    /* initializers */
    
    init(withAtlas atlas: SKTextureAtlas) {
        self.spriteAtlas = atlas
        self.boundingBox = BoundingBox(position: CGPointZero, of: CGSize(width: 128.0, height: 256.0))
        super.init(texture: self.spriteAtlas!.textureNamed("stand"), color: UIColor.whiteColor(), size: (self.spriteAtlas?.textureNamed("stand").size())!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* methods */
    
    private func checkAnimation() {
        // runs through appropriate animation frames in sequence
        state.runAnimation(self)
 
    }
    
    private func runPhysics(withGravity gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        // defines custom physics behavior for Player object
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

    
    func touchBehavior(first: CGPoint, next: CGPoint) {
        // defines behavior for touchesMoved
        self.state.touchBehavior(self, first: first, next: next)
    }
    
    func endTouchBehavior() {
        // defines behavior for touchesEnded
        self.state.endTouchBehavior(self)
        self.size = (self.texture?.size())!

    }

    func strike(enemy: Fighter) {
        let hitbox = Hitbox(position: CGPoint(x: self.position.x - 40, y: self.position.y + 40))
        let hitArea = enemy.boundingBox
        if didHit(area: hitArea, with: hitbox) {
            enemy.getHit()
        }
    }
    
    func getHit() {
        
    }
    
    func didHit(area object: BoundingBox, with box: Hitbox) -> Bool {
        if !(object.max.x < box.min.x || object.max.y < box.min.y || object.min.x > box.max.x || object.min.y > box.max.y) {
            return true
        }
        return false
    }
    
    func requestJump() {
        
    }
    
    func update(with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        // called once per frame
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