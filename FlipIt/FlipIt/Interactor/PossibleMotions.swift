//
//  PossibleMotions.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

enum PossibleMotions: Int {
    case noMotion = -1
    case faceLeft = 0
    case faceRight = 1
    case turnTowardsFace = 2
    case coverScreen = 3
	case faceUp = 4
	case faceDown = 5
    case pressVolume = 6
    case shake = 7
    
    var motions: String {
        switch self {
        case .faceLeft:
            return "Left"
        case .faceRight:
            return "Right"
        case .turnTowardsFace:
            return "Face"
        case .coverScreen:
            return "Cover \nScreen"
		case .faceUp:
			return "Up"
		case .faceDown:
			return "Down"
        case.pressVolume:
            return "Volume"
        case .shake:
            return "Shake"
        default:
            return "no Motion"
            
        }
    }
}