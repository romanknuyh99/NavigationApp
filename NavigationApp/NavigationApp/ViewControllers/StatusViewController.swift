//
//  StatusViewController.swift
//  NavigationApp
//
//  Created by Roman Kniukh on 8.02.21.
//

import UIKit

class StatusViewController: UIViewController {
    // MARK: - Variables
    var username: String?
    var status: RegisterStatus?
    var action: ((RegisterStatus) -> Void)?
    private var password: String?
    weak var delegate: SendingDataDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            self.infoLabel.textColor = .black
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            self.closeButton.setTitle("Close", for: .normal)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        if let usernameReceived = self.username {
            self.infoLabel.text = "Username: \(usernameReceived)"
        }
    }
    
    // MARK: - Setter
    func set(password: String) {
        self.password = password
        
        print("Password received: \(password)")
    }
    
    // MARK: - Actions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            
            if let `username` = self?.username, let `password` = self?.password {
                self?.getStatus(username: `username`, password: `password`)
            }
            
            if let statusReceived = self?.status {
                print("Status received is \(statusReceived)")
                self?.delegate?.changeColor(status: statusReceived)
                self?.action?(statusReceived)
                NotificationCenter.default.post(name: AuthViewController.notificationName,
                                                object: nil, userInfo: ["Status": statusReceived])
                
                NotificationCenter.default.post(name: .userDataWasUpdated,
                                                object: nil,
                                                userInfo: ["Status": statusReceived])
            }
        }
    }
    
    // MARK: - Methods
    func getStatus(username: String, password: String) {
        if username.count + password.count > 14 {
            self.status = .Confirmed
        } else {
            self.status = .Declined
        }
    }
}
