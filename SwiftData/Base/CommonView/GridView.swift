//
//  GridView.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/8/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

import Foundation
import Masonry

class GridView: UIScrollView {
    
    var provideWidth : CGFloat = 0
    var gridViewHeight : CGFloat = 0
    var singleViewSize : CGSize = CGSize.zero
    var singleViewShowDot = false
    
    class func gridView(width:CGFloat,config:GridViewConfigModel)->GridView {
        let gridView = GridView()
        gridView.isScrollEnabled = false
        gridView.showsVerticalScrollIndicator = false
        gridView.showsHorizontalScrollIndicator = false
        gridView.config = config
        gridView.provideWidth = width
        gridView.backgroundColor = UIColor.white
        return gridView
    }
    
    class func gridViewSingle(size:CGSize,config:GridViewConfigModel)->GridView {
        let gridView = GridView()
        gridView.showsVerticalScrollIndicator = false
        gridView.showsHorizontalScrollIndicator = false
        gridView.config = config
        gridView.singleViewSize = size
        gridView.backgroundColor = UIColor.white
        return gridView
    }
    
    
    func configItems(itemCount:NSInteger,fetchItem : ((_ i:NSInteger)->(UIView))?) {
        var itemW = (provideWidth - config.edge.left - config.edge.right - (config.colCount - 1) * config.itemColMargin) / config.colCount
        var itemH = config.itemHeight
        if config.isSingleLine {
            itemW = (singleViewSize.width - config.edge.left - config.edge.right - (config.colCount - 1) * config.itemColMargin) / config.colCount
            itemH = singleViewSize.height - config.edge.top - config.edge.bottom
        }
        if itemH == 0 {
            itemH = itemW
        }
        for subView in subviews {
            subView.removeFromSuperview()
        }
        childItems.removeAllObjects()
        if itemCount == 0 {
            return
        }
        if config.isSingleLine {
            for i in 0...Int(itemCount - 1) {
                let x = config.edge.left + CGFloat(i) * (itemW + config.itemColMargin)
                let y = config.edge.top
                
                if let item = fetchItem?(i) {
                    childItems.add(item)
                    addSubview(item)
                    item.tag = i
                    item.mas_makeConstraints({
                        $0?.left.mas_equalTo()(x)
                        $0?.top.mas_equalTo()(y)
                        $0?.size.mas_equalTo()(CGSize(width: itemW, height: itemH))
                    })
                    if singleViewShowDot {
                        if i > 0 && i < itemCount {
                            let lineDashHeight:CGFloat = 2
                            let lineDash = UIView.init(frame: CGRect(x: x - config.itemColMargin, y: y + itemH * 0.5 - lineDashHeight * 0.5, width: config.itemColMargin, height: lineDashHeight))
                            drawDashLine(lineView: lineDash, lineLength: 5, lineSpacing: 2, lineColor: UIColor.blue)
                            addSubview(lineDash)
                        }
                    }
                    if i == itemCount - 1 {
                        contentSize = CGSize(width: x + itemW + config.edge.left, height: 0)
                    }
                }
            }
            gridViewHeight = singleViewSize.height
        } else {
            for i in 0...Int(itemCount - 1) {
                let row = i / Int(config.colCount)
                let col = i % Int(config.colCount)
                let x = config.edge.left + CGFloat(col) * (itemW + config.itemColMargin);
                let y = config.edge.top + CGFloat(row) * (itemH + config.itemRowMargin)
                if let item = fetchItem?(i) {
                    childItems.add(item)
                    addSubview(item)
                    item.tag = i
                    item.mas_makeConstraints({
                        $0?.left.mas_equalTo()(x)
                        $0?.top.mas_equalTo()(y)
                        $0?.size.mas_equalTo()(CGSize(width: itemW, height: itemH))
                    })
                }
                if i == Int(itemCount - 1) {
                    gridViewHeight = y + itemH + config.edge.bottom + 8
                    contentSize = CGSize(width: 0, height: gridViewHeight)
                }
            }
        }
    }
    
    func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.strokeColor = lineColor.cgColor
        
        shapeLayer.lineWidth = lineView.frame.size.height
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))
        
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    //MARK:懒加载
    lazy var config:GridViewConfigModel = GridViewConfigModel()
    lazy var childItems:NSMutableArray = {
        var array = NSMutableArray()
        return array
    }()
    
}

class GridViewConfigModel: NSObject {
    var colCount : CGFloat = 4.0
    var itemHeight : CGFloat = 0
    var itemColMargin : CGFloat = 0
    var itemRowMargin : CGFloat = 0
    var isSingleLine : Bool = false
    var edge : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    class func model(colCount:CGFloat,
                     itemHeight:CGFloat,
                     itemColMargin:CGFloat,
                     itemRowMargin:CGFloat,
                     edge:UIEdgeInsets)->GridViewConfigModel {
        let model = GridViewConfigModel()
        model.colCount = colCount
        model.itemHeight = itemHeight
        model.itemColMargin = itemColMargin
        model.itemRowMargin = itemRowMargin
        model.isSingleLine = false
        model.edge = edge
        return model
    }
    
    class func modelSingle(colCount:CGFloat,
                     itemColMargin:CGFloat,
                     edge:UIEdgeInsets)->GridViewConfigModel {
        let model = GridViewConfigModel()
        model.colCount = colCount
        model.itemColMargin = itemColMargin
        model.isSingleLine = true
        model.edge = edge
        return model
    }
}
