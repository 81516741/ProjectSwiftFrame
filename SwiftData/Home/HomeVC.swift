//
//  ViewController.swift
//  SwiftData
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
class HomeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        navigationController?.ld_theme = .white
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(OtherVC(), animated: true)
    }
}


