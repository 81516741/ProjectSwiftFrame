//
//  Behavior.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class ButtonBehavior: LDBehavior {
    @IBOutlet var behaviors:[LDBehavior]!
    @IBOutlet var button:UIButton!
    @IBInspectable var disableColor:UIColor?
    @IBInspectable var normalColor:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.observer()
        }
    }
    
    func observer() {
        for behavior in behaviors {
            if behavior.isKind(of: TextFieldBehavior.classForCoder()) {
                let behavior1 = behavior as! TextFieldBehavior
                _ = behavior1.textField.rx.text.orEmpty.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](text) in
                    _ = self?.check()
                })
                
                _ = behavior1.textField.rx.observe(String.self, #keyPath(UITextField.text)).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](text) in
                    _ = self?.check()
                })
            }
            if behavior.isKind(of: ImageViewBehavior.classForCoder()) {
                let behavior1 = behavior as! ImageViewBehavior
                _ = behavior1.imageView.rx.observe(UIImage.self, #keyPath(UIImageView.image)).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](image) in
                    _ = self?.check()
                })
            }
        }
    }
    
    override func check() -> Bool{
        var buttonEnable = true
        for behavior in behaviors {
            buttonEnable = behavior.check()
            if !buttonEnable { break }
        }
        button.isEnabled = buttonEnable
        if buttonEnable {
            button.backgroundColor = normalColor ?? UIColor.red
        } else {
            button.backgroundColor = disableColor ?? UIColor.lightGray
        }
        return buttonEnable
    }
}
