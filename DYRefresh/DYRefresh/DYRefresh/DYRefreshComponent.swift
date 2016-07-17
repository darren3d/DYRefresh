//
//  DYRefreshComponent.swift
//  DYRefresh
//
//  Created by darrenyao on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

public typealias DYRefreshComponentBlock = @convention(block) () -> Void

enum DYRefreshState : Int16 {
    case Init = 0
    case Idle = 1
    case Pulling = 2
    case Refreshing = 3
    case WillRefresh = 4
    case NoMoreData = 5
}

class DYRefreshComponent: UIView {
    weak var scrollView : UIScrollView? {
        willSet {
            if newValue == scrollView {
                return
            }
            removeKVOObservers()
        }
        didSet {
            if oldValue == scrollView {
                return
            }
            
            guard let scrollView = scrollView else {
                scrollViewOriginalInset = UIEdgeInsetsZero
                return
            }
            
            scrollView.alwaysBounceVertical = true
            scrollViewOriginalInset = scrollView.contentInset
            addKVOObservers()
        }
    }
    
    var scrollViewOriginalInset : UIEdgeInsets = UIEdgeInsetsZero
    
    var state : DYRefreshState = DYRefreshState.Init {
        didSet {
            if oldValue == state {
                return
            }
            dispatch_async(dispatch_get_main_queue()) { 
                self.setNeedsLayout()
            }
        }
    }
    
    var refreshingBlock : DYRefreshComponentBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    /**设置*/
    func setupView() {
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.backgroundColor = UIColor.clearColor();
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (self.state == DYRefreshState.WillRefresh) {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = DYRefreshState.Refreshing;
        }
    }
    
    //MARK: KVO监听
    func addKVOObservers() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        let options = NSKeyValueObservingOptions.New//|NSKeyValueObservingOptions.Old;
        scrollView.addObserver(self,
                               forKeyPath: "contentOffset",
                               options: options,
                               context: nil)
        scrollView.addObserver(self,
                               forKeyPath: "contentSize",
                               options: options,
                               context: nil)
        
        let panGesture = scrollView.panGestureRecognizer
        panGesture.addObserver(self,
                               forKeyPath: "state",
                               options: options,
                               context: nil)
    }
    
    func removeKVOObservers() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        
        let panGesture = scrollView.panGestureRecognizer
        panGesture.removeObserver(self, forKeyPath: "state");
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // just return in cases
        if !self.userInteractionEnabled {
            return;
        }
        
        // process enven not visible
        if (keyPath == "contentSize") {
            scrollViewContentSizeDidChange(change)
        }
        
        if self.hidden {
            return
        }
        
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == "statie" {
            scrollViewPanStateDidChange(change)
        }
    }
    
    func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        
    }
    
    func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        
    }
    
    func scrollViewPanStateDidChange(change: [String : AnyObject]?) {
        
    }
    
    //MARK : Refresh
    var pullingPercent : CGFloat = 0.0
    func beginRefreshing() {
        UIView.animateWithDuration(0.25) { 
            self.alpha = 1.0
        }
        
        self.pullingPercent = 1.0
        
        if self.window != nil {
            self.state = DYRefreshState.Refreshing
        } else {
            if (self.state != DYRefreshState.Refreshing) {
                self.state = DYRefreshState.WillRefresh;
                self.setNeedsLayout();
            }
        }
    }
    
    func endRefreshing() {
        self.state = DYRefreshState.Idle;
    }
    
    func isRefreshing() -> Bool {
        return self.state == DYRefreshState.Refreshing || self.state == DYRefreshState.WillRefresh
    }
    
    //MARK: Internal Method
    
}