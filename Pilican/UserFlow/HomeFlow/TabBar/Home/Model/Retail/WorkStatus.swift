//
//  WorkStatus.swift
//  Pilican
//
//  Created by kairzhan on 2/23/21.
//

import UIKit

enum WorkStatus: Int {
    case closed
    case open

    var title: String {
        switch self {
        case .closed:
            return "Закрыто"
        case .open:
            return "Открыто"
        }
    }
    
    var backColor: UIColor {
        switch self {
        case .closed:
            return .workStatusPink
        case .open:
            return .workStatusGreen
        }
    }

    var textColor: UIColor {
        switch self {
        case .closed:
            return .workStatusTextPink
        case .open:
            return .workStatusTextGreen
        }
    }
}
