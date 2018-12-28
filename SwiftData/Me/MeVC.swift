//
//  Me.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(OtherVC1(), animated: true)
    }
}
