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
    
    var motionName: String {
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
    
    var motionDescribtion: String {
        switch self {
        case .faceLeft:
            return "Make your phone lie horizontally (as in landscape mode) with the screen facing left."
        case .faceRight:
            return "Make your phone lie horizontally (as in landscape mode) with the screen facing right."
        case .turnTowardsFace:
            return "Make your phone stand vertically (as in portrait mode) with the screen facing left "
        case .coverScreen:
            return "Cover your phone's screen. Make sure that the proximity sensor (circled in red) is covered"
        case .faceUp:
            return "Make the screen face upwards"
        case .faceDown:
            return "Make the screen face downwards"
        case.pressVolume:
            return "Press either of the volume buttons"
        case .shake:
            return "Shake your phone quickly then stop before the next command is given"
        default:
            return "no Motion"
        }
    }
}
