//
//  GameButton.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/23/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import Foundation
import SpriteKit

let BUTTON_WIDTH: CGFloat = 256.0
let BUTTON_HEIGHT: CGFloat = 256.0

class GameButton {
    
    var image: SKSpriteNode
    var position: CGPoint
    
    init(withImage image: String, atPosition position: CGPoint) {
        self.image = SKSpriteNode(imageNamed: image)
        self.position = position
        self.image.position = position
        self.image.size.width = BUTTON_WIDTH
        self.image.size.height = BUTTON_HEIGHT
    }
    
    func wasPressed(_ touchPoint: CGPoint) -> Bool {
        let xDiff = touchPoint.x - self.position.x
        let yDiff = touchPoint.y - self.position.y
        let totalDist = sqrt(xDiff * xDiff + yDiff * yDiff)
        if totalDist < (self.image.size.width / 2) { return true }
        return false
    }
    
    func execute(_ player: Fighter) -> Bool {
        
        return true
    }
}

/* Distinct GameButtons commands */

class JumpButton : GameButton {
    override func execute(_ player: Fighter) -> Bool {
        player.state.tryJump(player)
        
        return true
    }
}

class AttackButton : GameButton {
    override func execute(_ player: Fighter) -> Bool {
        player.state.tryAttack(player)
        
        return true
    }
}

class SpecialButton : GameButton {
    override func execute(_ player: Fighter) -> Bool {
        player.state.trySpecial(player)
        
        return true
    }
}

class BlockButton: GameButton {
    override func execute(_ player: Fighter) -> Bool {
        player.state.tryBlock(player)
        
        return true
    }
}
