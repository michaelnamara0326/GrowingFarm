//
//  CustomerController.swift
//  growingFarm
//
//  Created by Michael on 2021/5/11.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
class CustomerController:UIViewController{
    
    @IBOutlet weak var latitudeLabel:UILabel?
    @IBOutlet weak var longtitudeLabel:UILabel?
    @IBAction func signoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      performSegue(withIdentifier: "customerToMain", sender: self)
    }
}
