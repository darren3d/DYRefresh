//
//  UIScrollView+DYRefresh.swift
//  DYRefresh
//
//  Created by darren on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct UIScrollViewAssociatedKey {
        static var Header = "dy.uiscrollview.key.header"
        static var Footer = "dy.uiscrollview.key.footer"
    }
    
    var dy_header : DYRefreshHeader? {
        get {
            let header : DYRefreshHeader? = dy_getAssociatedObject(&UIScrollViewAssociatedKey.Header,
                                                                   policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return header
        }
        set {
            let oldHeader = self.dy_header
            let newHeader : DYRefreshHeader? = newValue
            if newHeader == oldHeader {
                return
            }
            
            oldHeader?.removeFromSuperview()
            
            if newHeader != nil {
                self.insertSubview(newHeader!, atIndex: 0)
            }
            
            dy_setAssociatedObject(&UIScrollViewAssociatedKey.Header,
                                   value: newHeader,
                                   policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    var dy_footer : DYRefreshFooter? {
        get {
            let footer : DYRefreshFooter? = dy_getAssociatedObject(&UIScrollViewAssociatedKey.Footer,
                                                                   policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return footer
        }
        set {
            let oldFooter = self.dy_footer
            let newFooter : DYRefreshFooter? = newValue
            if newFooter == oldFooter {
                return
            }
            
            oldFooter?.removeFromSuperview()
            
            if newFooter != nil {
                self.insertSubview(newFooter!, atIndex: 0)
            }
            
            dy_setAssociatedObject(&UIScrollViewAssociatedKey.Footer,
                                   value: newFooter,
                                   policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func dy_setupHeader(target target:AnyObject, selector:Selector, height: CGFloat = 60) {
        var frame = self.bounds
        frame.size.height = height
        let header = DYRefreshBallHeader.header(frame, target: target, selector: selector)
        header.scrollView = self
        header.backgroundColor = self.backgroundColor
        
        self.dy_header = header
    }
    
    func dy_setupFooter(target target:AnyObject, selector:Selector, height: CGFloat = 60) {
        var frame = self.bounds
        frame.size.height = height
        let footer = DYRefreshBallFooter.footer(frame, target: target, selector: selector)
        footer.scrollView = self
        footer.backgroundColor = self.backgroundColor
        
        self.dy_footer = footer
    }
}


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
