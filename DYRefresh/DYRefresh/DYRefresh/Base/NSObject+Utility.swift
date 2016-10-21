//
//  NSObject+Utility.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension NSObject {
    public func dy_getAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>, policy:objc_AssociationPolicy, initial: (() -> T)? = nil) -> T? {
        var value = objc_getAssociatedObject(self, key) as? T
        if value == nil && initial != nil  {
            value = initial!()
            objc_setAssociatedObject(self, key, value, policy)
        }
        return value
    }
    
    public func dy_setAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>, value: T?, policy:objc_AssociationPolicy) -> T? {
        objc_setAssociatedObject(self, key, value, policy)
        return value
    }
}
