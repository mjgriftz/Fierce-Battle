//
//  stageLoader.swift
//  FierceBattle
//
//  Created by Marcus Griffiths on 5/3/16.
//  Copyright © 2016 Griffy. All rights reserved.
//

import Foundation

protocol stageLoader {
   // Use this template to create stages from stored images
    var bg: String { get }
    var bg2: String { get }
    var bg3: String { get }
    var fg: String { get }
    var bgm: String { get }
}

class timrekStage : stageLoader {

    var bg = "theString"
    var bg2 = "a"
    var bg3 = "b"
    var fg = "z"
    var bgm = "w"

}