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
import Kingfisher
class FarmerVC:UIViewController{
    @IBOutlet weak var farmerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        farmerImage.makeRounded()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if let url=farmer.farmerInfos.Photo{
                self.farmerImage.kf.setImage(with: URL(string: url.urlEncoded()))
            }
            self.nameLabel.text="哈囉，\(farmer.farmerInfos.Name)！"
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//            if let url=farmer.farmerInfos.Photo{
//                self.farmerImage.kf.setImage(with: URL(string: url.urlEncoded()))
//            }
//            self.nameLabel.text="哈囉，\(farmer.farmerInfos.Name)！"
//        }
//    }
   

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
