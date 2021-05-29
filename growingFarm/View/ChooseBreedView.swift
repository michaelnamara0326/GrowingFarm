//
//  chooseBreedView.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/28.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

@IBDesignable class ChooseBreedView: UIView {

    var view:UIView!
    
    @IBAction func breedButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
         guard let view = Bundle.main.loadNibNamed("ChooseBreedView", owner: nil, options: nil)?.first as? UIView else { return nil }
         return view
     }
     
    }
