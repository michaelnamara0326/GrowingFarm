//
//  LoginVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit

public class LoginVC: UIViewController{
    
    @IBOutlet weak var people: UILabel!
    var People:String!
    public override func viewDidLoad() {
        people.text=People
    }
    
    @IBAction func segueToRegister(_ sender: UIButton) {
       performSegue(withIdentifier: "segueRegister", sender: sender)
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
