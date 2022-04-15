//
//  WarehouseVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/5.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import SCLAlertView

class WarehouseVC: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var coinLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        coinLabel.text=String(customer.customerGameDatas.Coin)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension WarehouseVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton:false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("取消"){
            return
        }
        _ = alert.addButton("確定") {
            if customer.customerGameDatas.Coin > 100{
                FetchData().updateCustomerGameData("coin", customer.customerGameDatas.Coin - 100)
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    self.coinLabel.text=String(customer.customerGameDatas.Coin)
                }
                _ = SCLAlertView().showSuccess("兌換成功", subTitle: "帳號剩餘\(customer.customerGameDatas.Coin - 100)稻穗幣")
            }
            else{
                _ = SCLAlertView().showError("您的金幣不足", subTitle: "無法兌換")
            }
        }
        switch indexPath.row{
        case 0:
            _ = alert.showWarning("農產品折扣金", subTitle: "確定要兌換嗎")
        case 1:
            _ = alert.showWarning("免費兌換有機蔬菜", subTitle: "確定要兌換嗎")
        default:
            _ = alert.showWarning("休閒農場門票乙張", subTitle: "確定要兌換嗎")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommdityCell") as! CommodityCell
        cell.setLabel(index: indexPath.row + 1)
//        cell.textLabel?.text="hello"
        return cell
    }
   
}
