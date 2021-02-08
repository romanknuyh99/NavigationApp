//
//  RegisterStatus.swift
//  NavigationApp
//
//  Created by Roman Kniukh on 8.02.21.
//

import UIKit

enum RegisterStatus {
    case Confirmed
    case Declined
}

extension RegisterStatus {
    var rawValue: UIColor {
        get {
            switch self {
            case .Confirmed:
                return .green
            case .Declined:
                return .red
            }
        }
    }
}
