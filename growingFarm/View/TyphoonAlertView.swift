//
//  TyphoonAlertView.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/31.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

@IBDesignable class TyphoonAlertView: UIView {
    override init(frame: CGRect) {
         super.init(frame: frame)
         print(#function)
         commonInit()
     }
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         print(#function)
     }
     
     func commonInit() {
         guard let view = loadViewFromNib() else { return }
         view.frame = self.bounds
         addSubview(view)
     }

     func loadViewFromNib() -> UIView? {
         print(#function)
         guard let view = Bundle.main.loadNibNamed("FarmerEventView", owner: nil, options: nil)?.first as? UIView else { return nil }
         return view
     }

}
