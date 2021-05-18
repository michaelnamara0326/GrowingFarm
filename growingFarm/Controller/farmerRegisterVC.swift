//
//  farmerRegisterVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/18.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class farmerRegisterVC:UIViewController{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerPressed(_ sender: UIButton) {
//            emailAuth()
//            setCustomerDataToDatabase()
//            updateCustomerCnt()
//            clearUserInput()
        self.performSegue(withIdentifier:"registertologin" , sender: self)
    }
    
}
