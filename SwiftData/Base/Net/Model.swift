//
//  Model.swift
//  RxMoya
//
//  Created by lingda on 2018/12/4.
//  Copyright © 2018年 ZhaoHeng. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Model: NSObject {
    @objc dynamic var replys:[Reply]?
    @objc dynamic var reply: Reply?
    override static func mj_objectClassInArray() -> [AnyHashable :Any]? {
        return ["replys" :NSStringFromClass(Reply.self)]
    }
}

class Reply: NSObject {
    @objc dynamic var errorcode: String = ""
    @objc dynamic var myIP: String = ""
    @objc dynamic var port: String = ""
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["myIP":"ip"]
    }
}


class Model0: Object {
    let replyList = List<Reply0>()
    @objc dynamic var reply: Reply0?
}

class Reply0: Object {
    @objc dynamic var errorcode: String = ""
    @objc dynamic var myIP: String = ""
    @objc dynamic var port: String = "默认port"
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["myIP":"ip"]
    }
}
