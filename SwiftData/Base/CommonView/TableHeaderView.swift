//
//  TableHeaderView.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/9/4.
//  Copyright © 2018年 tcl. All rights reserved.
//

import Foundation

class TableHeaderView:UIView {
    class func tableHeaderView()->TableHeaderView {
        let contentView = TableHeaderView()
        contentView.addSubview(contentView.label)
        contentView.label.mas_makeConstraints({
            $0?.left.equalTo()(TransSizeTool.transWidthSize(pxValue: 30))
            $0?.right.equalTo()(0)
            $0?.bottom.equalTo()(0)
            $0?.top.equalTo()(0)
        })
        contentView.backgroundColor = UIColor.lightGray
        return contentView
    }
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.text = "你好啊"
        label.textColor = UIColor.lightGray
        label.font = TransSizeTool.transFontSize(fontSize: 26)
        label.backgroundColor = UIColor.clear
        return label
    }()
}
