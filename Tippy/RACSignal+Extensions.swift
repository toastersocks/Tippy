//
//  RACSignal+Extensions.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa

// a collection of extension methods that allows for strongly typed closures
extension RACSignal {
    
    func subscribeNextAs<T>(_ nextClosure:@escaping (T) -> ()) -> () {
        self.subscribeNext {
            (next: Any!) -> () in
            let nextAsT = next! as! T
            nextClosure(nextAsT)
        }
    }
    
    func mapAs<T: AnyObject, U: AnyObject>(_ mapClosure:@escaping (T) -> U) -> RACSignal {
        return self.map {
            (next: Any!) -> AnyObject! in
            let nextAsT = next as! T
            return mapClosure(nextAsT)
        }
    }
    
    func filterAs<T: AnyObject>(_ filterClosure:@escaping (T) -> Bool) -> RACSignal {
        return self.filter {
            (next: Any!) -> Bool in
            let nextAsT = next as! T
            return filterClosure(nextAsT)
        }
    }
    
    func doNextAs<T: AnyObject>(_ nextClosure:@escaping (T) -> ()) -> RACSignal {
        return self.doNext {
            (next: Any!) -> () in
            let nextAsT = next as! T
            nextClosure(nextAsT)
        }
    }
}

class RACSignalEx {
    class func combineLatestAs<T, U, R: AnyObject>(_ signals:[RACSignal], reduce:@escaping (T,U) -> R) -> RACSignal {
        return RACSignal.combineLatest(signals as NSFastEnumeration!).mapAs {
            (tuple: RACTuple) -> R in
            return reduce(tuple.first as! T, tuple.second as! U)
        }
    }
}
