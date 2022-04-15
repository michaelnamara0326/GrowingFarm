//
//  CreateEventVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/30.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import EFQRCode
import SCLAlertView
class ShowEventVC: UIViewController {
    var passIndexPath:Int?
    @IBOutlet var tableView:UITableView!
    override func viewDidLoad() {
        tableView.delegate=self
        tableView.dataSource=self
    }
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "showToCreate", sender: self)
    }
}
extension ShowEventVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passIndexPath=indexPath.row+1
        performSegue(withIdentifier: "toShowQRCode", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farmer.farmerGameDatas.Event.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.setLabel(index: indexPath.row + 1)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowQRCode"{
            let vc=segue.destination as! ShowQRCodeVC
            vc.indexPathRow=passIndexPath!
        }
    }
}

