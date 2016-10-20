//
//  DYRefreshBallHeader.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYRefreshBallHeader: DYRefreshHeader {
    var ballView:DYBallView!
    var waveView:DYWaveView!
    
    var waveColor: UIColor? {
        get {
            return self.waveView.waveColor
        }
        set {
            self.waveView.waveColor = newValue
        }
    }
    
    override var state: DYRefreshState {
        didSet {
            let newState = state
            let oldState = oldValue
            if oldState == newState {
                return
            }
            
            switch newState {
            case DYRefreshState.Idle:
                break
//                waveView.alpha = 0
            case DYRefreshState.Pulling:
//                waveView.alpha = 1
                break
            case DYRefreshState.Refreshing:
                let offset = self.pullingPercent * self.bounds.size.height
                wave(offset)
                didRelease(offset)
                break
            default: break
                
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            var percent = min(pullingPercent, 1.0)
            percent = max(percent, 0.0)
            let offset = self.pullingPercent * self.bounds.size.height
            wave(offset)
        }
    }
    
    override class func header(frame:CGRect, block:DYRefreshComponentBlock? = nil) -> DYRefreshHeader {
        let header = DYRefreshBallHeader(frame: frame)
        header.refreshingBlock = block
        header.waveColor = UIColor.lightGrayColor()
        return header
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        waveView = DYWaveView(frame: bounds)
        addSubview(waveView)
        
        ballView = DYBallView(frame: bounds)
        addSubview(ballView)
        ballView.hidden = true
        
        waveView.didEndPull = { [weak self] in
            self?.ballView.hidden = false
            self?.ballView.startAnimation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        waveView.frame = self.bounds
        ballView.frame = self.bounds
    }
    
    func endAnimation(complition:(()->())? = nil) {
        ballView.endAnimation()
        complition?()
    }
    
    func wave(y: CGFloat) {
        waveView.wave(y)
    }
    
    func didRelease(y: CGFloat) {
        waveView.didRelease(y)
    }
}
