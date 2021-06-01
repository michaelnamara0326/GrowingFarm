//
//  FarmerController.swift
//  growingFarm
//
//  Created by Michael on 2021/5/11.
//  Copyright © 2021 Michael. All rights reserved.
//
//get farmer name, address
import Foundation
import UIKit
import Firebase
class FarmerVC:UIViewController{
    let fetchData=FetchData()
    @IBOutlet weak var farmerImage: UIImageView!
    override func viewDidLoad() {
        farmerImage.makeRounded()
        fetchData.getFarmerInfo()
        fetchData.getFarmerGameData()
    }

    @IBAction func signoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }

}
extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
