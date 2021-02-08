//
//  AuthViewController.swift
//  NavigationApp
//
//  Created by Roman Kniukh on 8.02.21.
//

import UIKit

class AuthViewController: UIViewController {
    // MARK: - Notifications
    static let notificationName = Notification.Name("CustomNotificationName")

    // MARK: - Outlets
    @IBOutlet weak var hiddenLabel: UILabel! {
        didSet {
            self.hiddenLabel.isHidden = true
            self.hiddenLabel.textColor = .black
        }
    }
    @IBOutlet weak var usernameField: UITextField! {
        didSet {
            self.usernameField.placeholder = "Pleace, enter your username"
        }
    }
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            self.passwordField.placeholder = "Pleace, enter your password"
            self.passwordField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            self.registerButton.setTitle("Register", for: .normal)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendDataWithObserver(notification:)), name: AuthViewController.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendDataWithObserver(notification:)), name: .userDataWasUpdated, object: nil)
    }
    
    // MARK: - Actions
    @IBAction func registerBtnWasPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "StatusViewController") as? StatusViewController {
            
            destinationVC.set(password: passwordField.text ?? "")
            destinationVC.username = self.usernameField.text ?? ""
            destinationVC.delegate = self
            destinationVC.action = { status in
                print(status)
                
                // show hidden label
                if status == .Confirmed {
                    self.hiddenLabel.isHidden = false
                    self.hiddenLabel.backgroundColor = .blue
                    self.hiddenLabel.textColor = .white
                    self.hiddenLabel.text = "Добро пожаловать, \(self.usernameField.text ?? "")"
                } else {
                    self.hiddenLabel.isHidden = false
                    self.hiddenLabel.backgroundColor = .systemOrange
                    self.hiddenLabel.textColor = .white
                    self.hiddenLabel.text = "Ошибка"
                }
            }
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    // MARK: - Methods
    @objc private func sendDataWithObserver(notification: Notification) {
        if let userInfo = notification.userInfo {
            print("User status should be: \(userInfo["Status"] ?? "unknown")")
            
            if let userInfoStatus = userInfo["Status"] as? RegisterStatus {
                switch userInfoStatus {
                case .Confirmed:
                    print("User confirmed")
                    // show alert (using alert router)
                    AlertRouter.shared.show(for: self, title: "Статус пользователя", message: "Вы успешно зарегистрировались", preferredStyle: .alert, buttonTitle: "Close alert", buttonStyle: .default, handlerText: "Close button was pressed", controllerText: "User registered successfully")
                case .Declined:
                    print("User declined")
                    // show alert (using alert router)
                    AlertRouter.shared.show(for: self, title: "Статус пользователя", message: "Регистрация не удалась", preferredStyle: .alert, buttonTitle: "Close alert", buttonStyle: .destructive, handlerText: "Destruct button was pressed", controllerText: "Registration failed")
                }
            }
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StatusViewController
        {
            if let usernameText = usernameField.text {
                vc.username = usernameText
            }
        }
    }
    
}

// MARK: - Delegate
extension AuthViewController: SendingDataDelegate {
    func changeColor(status: RegisterStatus) {
        self.view.backgroundColor = status.rawValue
    }
}
