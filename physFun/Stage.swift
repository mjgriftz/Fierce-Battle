//
//  Stage.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/23/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import Foundation
import SpriteKit

class Stage {
    
    let background: SKSpriteNode 
    let leftBound = 0.0
    let rightBound: CGFloat = 2048.0
    let floor: CGFloat = 352.0
    let grav: CGFloat = -0.7
    
    init(stageImage: String) {
        self.background = SKSpriteNode(imageNamed: stageImage)
    }
}