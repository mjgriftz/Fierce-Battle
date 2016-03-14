//
//  FighterState.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/12/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import Foundation
import SpriteKit

protocol FighterState {
    func runAnimation(fighter: Fighter)
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint)
    func endTouchBehavior(fighter: Fighter)
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat)
    func entryBehavior(fighter: Fighter)
}

class jumpState : FighterState {
    func runAnimation(fighter: Fighter) {
        
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint){
        
    }
    
    func endTouchBehavior(fighter: Fighter) {

    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.runAnimation(fighter)
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        if fighter.velocityY == 0.0 { fighter.nextState = standState () }
    }
    
    func entryBehavior(fighter: Fighter) {
        fighter.texture = fighter.spriteAtlas?.textureNamed("high")
        fighter.velocityY += 15
    }
}

class standState : FighterState {
    func runAnimation(fighter: Fighter) {
        
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
        fighter.velocityX = (next.x - first.x) * 0.5
        if abs(fighter.velocityX) > 0.0 { fighter.nextState = runState() }
        
    }
    
    func endTouchBehavior(fighter: Fighter) {
        
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.runAnimation(fighter)
    }
    
    func entryBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
        fighter.texture = fighter.spriteAtlas!.textureNamed("stand")
    }
}
class runState : FighterState {
    func runAnimation(fighter: Fighter) {
        if fighter.currentFrame == fighter.frames.count * Fighter.frameDuration { fighter.currentFrame = 0 }
        fighter.texture = fighter.spriteAtlas!.textureNamed(fighter.frames[Int(fighter.currentFrame / Fighter.frameDuration)])
        fighter.size = (fighter.texture?.size())!
        fighter.currentFrame += 1
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
        fighter.velocityX = (next.x - first.x) * 0.5

         if fighter.velocityX == 0.0 { fighter.nextState = standState() }

    }
    
    func endTouchBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.runAnimation(fighter)
        if fighter.velocityX == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(fighter: Fighter) {
        
    }
}

