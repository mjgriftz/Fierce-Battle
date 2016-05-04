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
    func tryJump(fighter: Fighter)
    func tryBlock(fighter: Fighter)
    func tryAttack(fighter: Fighter)
    func trySpecial(fighter: Fighter)
    func tryDmg(fighter: Fighter)
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
    
    func tryJump(fighter: Fighter) {
        // Jump disabled during state
    }
    func tryAttack(fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(fighter: Fighter) {
        
        // Block disabled during state
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        fighter.nextState = dmgState()
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
    
    func tryJump(fighter: Fighter) {
        fighter.nextState = jumpState()
    }
    func tryAttack(fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class runState : FighterState {

    func runAnimation(fighter: Fighter) {
        if fighter.currentWalkFrame == fighter.walkFrames.count * Fighter.frameDuration { fighter.currentWalkFrame = 0 }
        fighter.texture = fighter.spriteAtlas!.textureNamed(fighter.walkFrames[Int(fighter.currentWalkFrame / Fighter.frameDuration)])
        fighter.size = (fighter.texture?.size())! // Extraneous specification due to SpriteKit bug ** TODO: Check if still necessary
        fighter.currentWalkFrame += 1
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
    
    func tryJump(fighter: Fighter) {
        fighter.nextState = jumpState()
    }
    func tryAttack(fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class atkState : FighterState {
    var timer = 12
    func runAnimation(fighter: Fighter) {
        if fighter.currentAtkFrame >= fighter.atkFrames.count * 3 { fighter.currentAtkFrame = 0 }
        fighter.texture = fighter.spriteAtlas!.textureNamed(fighter.atkFrames[Int(fighter.currentAtkFrame / 3)])
        fighter.currentAtkFrame += 1

    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
    
    }
    
    func endTouchBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
        self.runAnimation(fighter)
    }
    
    func entryBehavior(fighter: Fighter) {
        let attackBox = Hitbox(position: CGPoint(x: fighter.position.x - 40, y: fighter.position.y), of: CGSize(width: 30, height: 30))
        
        /* Remove from release */
        
        let testBox = SKSpriteNode(color: UIColor.blueColor(), size: attackBox.size)
        testBox.position = attackBox.position
        fighter.addChild(testBox)
        
        /* /////////////////// */
        
        if fighter.didHit(with: attackBox) {
            fighter.opponent?.state.tryDmg(fighter.opponent!)
        }
        fighter.currentAtkFrame = 0
    }
    
    func tryJump(fighter: Fighter) {

    }
    func tryAttack(fighter: Fighter){
        
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class blockState : FighterState {
    var timer = 10
    func runAnimation(fighter: Fighter) {
        
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.timer -= 1;
        if self.timer == 0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(fighter: Fighter) {
        
    }
    
    func tryJump(fighter: Fighter) {
        
    }
    func tryAttack(fighter: Fighter){
        
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        
    }
}

class specialState : FighterState {
    var timer = 10
    func runAnimation(fighter: Fighter) {
        
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(fighter: Fighter) {
        
    }
    
    func tryJump(fighter: Fighter) {
        
    }
    func tryAttack(fighter: Fighter){
        
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class dmgState : FighterState {
    var timer = 15
    func runAnimation(fighter: Fighter) {
        
    }
    
    func touchBehavior(fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(fighter: Fighter) {
        fighter.texture = fighter.spriteAtlas?.textureNamed("hurt")
    }
    
    func tryJump(fighter: Fighter) {
        
    }
    func tryAttack(fighter: Fighter){
        
    }
    func tryBlock(fighter: Fighter) {
        
    }
    func trySpecial(fighter: Fighter) {
        
    }
    func tryDmg(fighter: Fighter) {
        
        //invulnerable until neutral state is restored
        
    }
}
