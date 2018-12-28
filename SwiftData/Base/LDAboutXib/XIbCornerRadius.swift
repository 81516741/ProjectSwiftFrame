//
//  ddd.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return 1.0 }
        set { layer.cornerRadius = newValue }
    }
}
