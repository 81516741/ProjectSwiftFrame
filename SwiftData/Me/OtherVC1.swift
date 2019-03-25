//
//  OtherVC1.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class OtherVC1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        title = "好的"
        ld_theme = NaviBarThemeBlue
        ld_naviBarColor = UIColor.red
        ld_setNaviBarRightItemText("你妹的", color: UIColor.white, sel: #selector(nimeide))
    }
    
    @objc func nimeide() {
        ld_setRightItemEnable(false)
    }

    

}
