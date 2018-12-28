//
//  DBTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/17.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm


class DBTool: NSObject {
    static let realm = try! Realm()
    class func getModels()->Results<Model0> {
       return realm.objects(Model0.self)
    }
    class func updateLastModelReplyPort(port:String) {
        try! realm.write {
            DBTool.getModels().last?.reply?.port = port
        }
    }
    class func saveModel(model:Model0) {
        try! realm.write {
            realm.add(model)
        }
    }
    class func delete<O: Object>(onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {
        return Realm.rx.delete(onError: onError)
    }
}
