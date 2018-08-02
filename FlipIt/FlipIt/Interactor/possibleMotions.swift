//
//  possibleMotions.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

enum possibleMotions: Int {
    case noMotion = -1
    case faceLeft = 0
    case faceRight = 1
    case turnTowardsFace = 2
    case coverScreen = 3
	case faceUp = 4
	case faceDown = 5
    case pressVolume = 6
    
    var action: String {
        switch self {
        case .faceLeft:
            return "Left"
        case .faceRight:
            return "Right"
        case .turnTowardsFace:
            return "Face"
        case .coverScreen:
            return "cover Screen"
		case .faceUp:
			return "Up"
		case .faceDown:
			return "down"
        case.pressVolume:
            return "volume"
        default:
            return "no Motion"
            
        }
    }
}
