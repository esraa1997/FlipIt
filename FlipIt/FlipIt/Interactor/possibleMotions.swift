//
//  possibleMotions.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

enum possibleMotions: Int {
    case noMotion = -1
    case tiltedToTheLeft = 0
    case tiltedToTheRight = 1
    case tiltedTowardsFace = 2
    case tiltedAwayFromFace = 3
    case touchedScreen = 4
    
    var action: String {
        switch self {
        case .tiltedToTheLeft:
            return "Left"
        case .tiltedToTheRight:
            return "Right"
        case .tiltedTowardsFace:
            return "Face"
        case .tiltedAwayFromFace:
            return "Back"
        case .touchedScreen:
            return "cover Screen"
        default:
            return "no Motion"
            
        }
    }
}
