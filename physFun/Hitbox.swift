//
//  Hitbox.swift
//  physFun
//
//  Created by Marcus Griffiths on 2/11/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import Foundation
import SpriteKit

struct Hitbox {
    var min: CGPoint {
        let minX = self.position.x - (size.width / 2)
        let minY = self.position.y - (size.width / 2)
        return CGPoint(x: minX, y: minY)
    }
    var max: CGPoint {
        let maxX = self.position.x + (size.width / 2)
        let maxY = self.position.y + (size.width / 2)
        return CGPoint(x: maxX, y: maxY)
    }
    var size: CGSize
    var position: CGPoint
    
    init (position: CGPoint) {
        self.position = position
        self.size = CGSize(width: 64.0, height: 64.0)
    }
    
    init (position: CGPoint, of size: CGSize) {
        self.position = position
        self.size = size
    }
}