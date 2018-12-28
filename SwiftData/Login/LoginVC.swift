//
//  LoginVC.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ld_hideNavigationBar = true
    }
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        LDConfigVCUtil.configTabCToRootVC()
    }
    
}
