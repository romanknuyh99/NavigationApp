//
//  Alerts.swift
//  NavigationApp
//
//  Created by Roman Kniukh on 8.02.21.
//

import UIKit

class AlertRouter {
    // MARK: - Singleton
    static let shared = AlertRouter()

    // MARK: - Initialization
    private init() { }

    // MARK: - Methods
    func show(for controller: UIViewController,
              title: String,
              message: String,
              preferredStyle: UIAlertController.Style,
              buttonTitle: String,
              buttonStyle: UIAlertAction.Style,
              handlerText: String,
              controllerText: String) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        
        alertController.addAction(
            UIAlertAction(
                title: buttonTitle,
                style: buttonStyle,
                handler: { (_) in
                    print(handlerText)
                }))
        
        controller.present(alertController, animated: true) {
            print(controllerText)
        }
    }
}

extension AlertRouter: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
