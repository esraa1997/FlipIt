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
    case touchedScreen = 3
	case up = 4
	case down = 5
    
    var action: String {
        switch self {
        case .tiltedToTheLeft:
            return "turn Left"
        case .tiltedToTheRight:
            return "turn Right"
        case .tiltedTowardsFace:
            return "tilt towards Face"
        case .touchedScreen:
            return "cover Screen"
		case .up:
			return "turn Up"
		case .down:
			return "turn down"
        default:
            return "no Motion"
            
        }
    }
}
