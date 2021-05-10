//
//  RegisterVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterVC:UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
//    @IBAction func registerPressed(_ sender: UIButton) {
//        if let email=emailTextField.text,let password=passwordTextField.text{
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//        }
//        }
//    }
    
}
