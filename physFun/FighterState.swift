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

    func runAnimation(_ fighter: Fighter)
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint)
    func endTouchBehavior(_ fighter: Fighter)
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat)
    func entryBehavior(_ fighter: Fighter)
    func tryJump(_ fighter: Fighter)
    func tryBlock(_ fighter: Fighter)
    func tryAttack(_ fighter: Fighter)
    func trySpecial(_ fighter: Fighter)
    func tryDmg(_ fighter: Fighter)
}

class jumpState : FighterState {

    func runAnimation(_ fighter: Fighter) {
        
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint){
        
    }
    
    func endTouchBehavior(_ fighter: Fighter) {

    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.runAnimation(fighter)
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        if fighter.velocityY == 0.0 { fighter.nextState = standState () }
    }
    
    func entryBehavior(_ fighter: Fighter) {
        fighter.texture = fighter.spriteAtlas?.textureNamed("high")
        fighter.velocityY += 15
    }
    
    func tryJump(_ fighter: Fighter) {
        // Jump disabled during state
    }
    func tryAttack(_ fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(_ fighter: Fighter) {
        
        // Block disabled during state
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class standState : FighterState {

    func runAnimation(_ fighter: Fighter) {
        
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
        fighter.velocityX = (next.x - first.x) * 0.5
        if abs(fighter.velocityX) > 0.0 { fighter.nextState = runState() }
        
    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.runAnimation(fighter)
    }
    
    func entryBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
        fighter.texture = fighter.spriteAtlas!.textureNamed("stand")
    }
    
    func tryJump(_ fighter: Fighter) {
        fighter.nextState = jumpState()
    }
    func tryAttack(_ fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class runState : FighterState {

    func runAnimation(_ fighter: Fighter) {
        if fighter.currentWalkFrame == fighter.walkFrames.count * Fighter.frameDuration { fighter.currentWalkFrame = 0 }
        fighter.texture = fighter.spriteAtlas!.textureNamed(fighter.walkFrames[Int(fighter.currentWalkFrame / Fighter.frameDuration)])
        fighter.size = (fighter.texture?.size())! // Extraneous specification due to SpriteKit bug ** TODO: Check if still necessary
        fighter.currentWalkFrame += 1
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
        fighter.velocityX = (next.x - first.x) * 0.5

         if fighter.velocityX == 0.0 { fighter.nextState = standState() }

    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.runAnimation(fighter)
        if fighter.velocityX == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(_ fighter: Fighter) {
        
    }
    
    func tryJump(_ fighter: Fighter) {
        fighter.nextState = jumpState()
    }
    func tryAttack(_ fighter: Fighter){
        fighter.nextState = atkState()
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class atkState : FighterState {
    var timer = 12
    func runAnimation(_ fighter: Fighter) {
        if fighter.currentAtkFrame >= fighter.atkFrames.count * 3 { fighter.currentAtkFrame = 0 }
        fighter.texture = fighter.spriteAtlas!.textureNamed(fighter.atkFrames[Int(fighter.currentAtkFrame / 3)])
        fighter.currentAtkFrame += 1

    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
    
    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
        self.runAnimation(fighter)
    }
    
    func entryBehavior(_ fighter: Fighter) {
        let attackBox = Hitbox(position: CGPoint(x: fighter.position.x - 40, y: fighter.position.y), of: CGSize(width: 40, height: 40))
        
        /* Remove from release */
        
        let testBox = SKSpriteNode(color: UIColor.blue, size: attackBox.size)
        testBox.position = attackBox.position
        
        /* /////////////////// */
        
        if fighter.didHit(with: attackBox) {
            fighter.opponent?.state.tryDmg(fighter.opponent!)
        }
        fighter.currentAtkFrame = 0
    }
    
    func tryJump(_ fighter: Fighter) {

    }
    func tryAttack(_ fighter: Fighter){
        
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class blockState : FighterState {
    var timer = 10
    func runAnimation(_ fighter: Fighter) {
        
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        self.timer -= 1;
        if self.timer == 0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(_ fighter: Fighter) {
        
    }
    
    func tryJump(_ fighter: Fighter) {
        
    }
    func tryAttack(_ fighter: Fighter){
        
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        
    }
}

class specialState : FighterState {
    var timer = 10
    func runAnimation(_ fighter: Fighter) {
        
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(_ fighter: Fighter) {
        
    }
    
    func tryJump(_ fighter: Fighter) {
        
    }
    func tryAttack(_ fighter: Fighter){
        
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        fighter.nextState = dmgState()
    }
}

class dmgState : FighterState {
    var timer = 15
    
    
    func runAnimation(_ fighter: Fighter) {
        
    }
    
    func touchBehavior(_ fighter: Fighter, first: CGPoint, next: CGPoint) {
        
    }
    
    func endTouchBehavior(_ fighter: Fighter) {
        fighter.velocityX = 0.0
    }
    
    func update(_ fighter: Fighter, with gravity: CGFloat, floor: CGFloat, right: CGFloat) {
        if fighter.velocityX > Fighter.maxVelocityX { fighter.velocityX = Fighter.maxVelocityX;}
        if fighter.velocityX < -Fighter.maxVelocityX { fighter.velocityX = -Fighter.maxVelocityX;}
        fighter.position.x += fighter.velocityX * Fighter.inputSensitivity
        self.timer -= 1;
        if self.timer <= 0 && fighter.velocityY == 0.0 { fighter.nextState = standState() }
    }
    
    func entryBehavior(_ fighter: Fighter) {
        // TEST CODE
        if fighter.hp > 0 {
            fighter.hp -= 7
        }
        if fighter.hp < 0 {
            fighter.hp = 0;
        }
        
        // *** ***
        fighter.texture = fighter.spriteAtlas?.textureNamed("hurt")
    }
    
    func tryJump(_ fighter: Fighter) {
        
    }
    func tryAttack(_ fighter: Fighter){
        
    }
    func tryBlock(_ fighter: Fighter) {
        
    }
    func trySpecial(_ fighter: Fighter) {
        
    }
    func tryDmg(_ fighter: Fighter) {
        
        //invulnerable until neutral state is restored
        
    }
}
