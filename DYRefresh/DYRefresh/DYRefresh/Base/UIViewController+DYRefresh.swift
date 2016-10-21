//
//  UIViewController+DYRefresh.swift
//  DYRefresh
//
//  Created by darrenyao on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension UIViewController {
    func dy_setupRefresh(setHeader : Bool, setFooter : Bool, scrollView : UIScrollView) {
        if setHeader {
            dy_setupHeader(scrollView)
        }
        
        if setFooter {
            dy_setupFooter(scrollView)
        }
    }
    
    func dy_setupHeader(scrollView : UIScrollView) {
        let header = DYRefreshBallHeader.header(CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 60)) { [weak self] in
            self?.dy_updateData()
        }
        header.scrollView = scrollView
        header.backgroundColor = UIColor.blueColor()
        
        scrollView.dy_header = header
    }
    
    func dy_setupFooter(scrollView : UIScrollView) {
        let footer = DYRefreshBallFooter.footer(CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 60)) { [weak self] in
            self?.dy_loadMoreData()
        }
        footer.scrollView = scrollView
        
        scrollView.dy_footer = footer
    }
    
    func dy_updateData() {
    }
    
    func dy_loadMoreData() {
    }
    
    func dy_endRefreshUpdate() {
        
    }
    
    func dy_endRefreshLoadMore() {
        
    }
}
