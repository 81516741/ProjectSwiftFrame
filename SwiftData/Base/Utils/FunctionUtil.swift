//
//  File.swift
//  SwiftData
//
//  Created by lingda on 2018/12/19.
//  Copyright © 2018年 lingda. All rights reserved.
//

import Foundation

let isTest = true

func msgID(_ flag:String)->String {
    let date = NSDate()
    let uniquNum = Int(date.timeIntervalSince1970 * 1000) + Int(arc4random() % 10000)
    let msgID = "\(flag)（\(uniquNum)）"
    return msgID
}
func Log<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    if isTest {
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))-\(messsage)")
    }
}

func startTimer(timeInterval:TimeInterval,handler:@escaping (()->()))->DispatchSourceTimer {
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        DispatchQueue.main.async { handler() }
    }
    timer.resume()
    return timer
}
