//
//  XibConstraintAdapter.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let referenceWidthSize : CGFloat = 375.0
let referenceHeightSize : CGFloat = 667.0
extension NSLayoutConstraint {
    @IBInspectable var adjustWidth: Bool {
        get { return true }
        set {
            if newValue {
                self.constant = self.constant * UIScreen.main.bounds.width / referenceWidthSize
            }
        }
    }
    @IBInspectable var adjustHeight: Bool {
        get { return true }
        set {
            if newValue {
                self.constant = self.constant * UIScreen.main.bounds.height / referenceHeightSize
            }
        }
    }
}

