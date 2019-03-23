//
//  ThreadClass.swift
//  
//
//  Created by Abdullah Jacksi on 3/23/19.
//

import Foundation




class ThreadClass {
    
    static let concurrentQueue = DispatchQueue(label: "AppNameConcurrentQueue", attributes: .concurrent)
    static let serialQueue = DispatchQueue(label: "AppNameSerialQueue")
    
    // Main Queue
    class func performTaskInMainQueue(task: @escaping ()->()) {
        DispatchQueue.main.async {
            task()
        }
    }
    
    // Background Queue
    class func performTaskInBackground(task:@escaping () throws -> ()) {
        DispatchQueue.global(qos: .background).async {
            do {
                try task()
            } catch let error as NSError {
                print("error in background thread:\(error.localizedDescription)")
            }
        }
    }
    
    // Concurrent Queue
    class func perfromTaskInConcurrentQueue(task:@escaping () throws -> ()) {
        concurrentQueue.async {
            do {
                try task()
            } catch let error as NSError {
                print("error in Concurrent Queue:\(error.localizedDescription)")
            }
        }
    }
    
    // Serial Queue
    class func perfromTaskInSerialQueue(task:@escaping () throws -> ()) {
        serialQueue.async {
            do {
                try task()
            } catch let error as NSError {
                print("error in Serial Queue:\(error.localizedDescription)")
            }
        }
    }
    
    // Perform task afterDelay
    class func performTaskAfterDealy(_ timeInteval: TimeInterval, _ task:@escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: (.now() + timeInteval)) {
            task()
        }
    }
}
