//
//  TextFieBehavior.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class TextFieldBehavior: LDBehavior {
    @IBInspectable var minTextLength: NSInteger = 0 {
        didSet {
            blocks.append { [weak self]() -> (Bool) in
                if let text = self!.textField.text {
                    if text.count >= self!.minTextLength {
                        return true
                    }
                }
                return false
            }
        }
    }
    @IBInspectable var textLength: NSInteger = 0 {
        didSet {
            blocks.append { [weak self]() -> (Bool) in
                if let text = self!.textField.text {
                    //当有定义最小长度时，就textLength只控制文字长度
                    if self!.minTextLength > 0 || text.count > self!.textLength{
                        if text.count > self!.textLength {
                            self!.textField.text = (text as NSString).substring(to: self!.textLength)
                        }
                        return true
                    } else {
                        if text.count == self!.textLength {
                            return true
                        }
                    }
                    
                    
                }
                return false
            }
        }
    }
    @IBOutlet var textField : UITextField! {
        didSet {
            _ = textField.rx.text.orEmpty.takeUntil(self.rx.deallocated).subscribe({ [weak self](text) in
                _ = self?.check()
            })
            
            _ = textField.rx.observe(String.self, #keyPath(UITextField.text)).takeUntil(self.rx.deallocated).subscribe({ [weak self](text) in
                _ = self?.check()
            })
        }
    }
    
    
    override func check() -> Bool {
        var result = true
        for block in blocks {
            result = block()
            if result == false { break }
        }
        return result
    }
    
    lazy var blocks:[()->(Bool)] = {
       return [()->(Bool)]()
    }()
}
