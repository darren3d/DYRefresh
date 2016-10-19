//
//  DYBallView.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYBallView: UIView {
    var moveUpDuration: Double = 0.7
    var moveUpDist: CGFloat = 32 * 1.5
    var circleSize: CGFloat = 20
    var circleSpace: CGFloat = 8.0
    var circleColor = UIColor.lightGrayColor()
    
    
    private var didStarUpAnimation: (()->())?
    private var circleMoveView: CircleMoveView?
    private var endFloatAnimation: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        for i in 3.stride(through: 0, by: -1) {
            circleMoveView = CircleMoveView.init(frame: frame, circleSize: circleSize, moveUpDist: moveUpDist, color: circleColor)
            circleMoveView!.tag = 100 + i
            self.addSubview(circleMoveView!)
        }
        
        self.didStarUpAnimation = { [weak self] in
            guard let sSelf = self else {
                return
            }
            
            for i in 3.stride(through: 0, by: -1) {
                sSelf.circleMoveView = sSelf.viewWithTag(100 + i) as? CircleMoveView
                sSelf.circleMoveView?.circleLayer.startAnimationUp(i,
                                                                  duration: sSelf.moveUpDuration,
                                                                  circleSize: sSelf.circleSize,
                                                                  circleSpace: sSelf.circleSpace,
                                                                  viewWidth: sSelf.circleMoveView!.bounds.size.width)
            }
        }
        self.endFloatAnimation = { [weak self] in
            guard let sSelf = self else {
                return
            }
            
            for i in 3.stride(through: 0, by: -1) {
                sSelf.circleMoveView = sSelf.viewWithTag(100 + i) as? CircleMoveView
                sSelf.circleMoveView!.circleLayer.stopFloatAnimation(i)
            }
        }
    }

}

class CircleMoveView: UIView {
    
    var circleLayer: CircleLayer!
    
    init(frame: CGRect, circleSize: CGFloat, moveUpDist: CGFloat, color: UIColor) {
        super.init(frame: frame)
        
        circleLayer = CircleLayer(
            size: circleSize,
            moveUpDist: moveUpDist,
            superViewFrame: self.frame,
            color: color
        )
        self.layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CircleLayer :CAShapeLayer,CAAnimationDelegate {
    
    var timer:NSTimer?
    var moveUpDist: CGFloat!
    var didEndAnimation: (()->())?
    
    var layerTag: Int?
    
    init(size:CGFloat, moveUpDist:CGFloat, superViewFrame:CGRect, color:UIColor) {
        self.moveUpDist = moveUpDist
        let selfFrame = CGRect(x: 0, y: 0, width: superViewFrame.size.width, height: superViewFrame.size.height)
        super.init()
        
        let radius:CGFloat = size / 2
        self.frame = selfFrame
        let center = CGPoint(x: superViewFrame.size.width / 2, y: superViewFrame.size.height/2)
        let startAngle = 0 - M_PI_2
        let endAngle = M_PI * 2 - M_PI_2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        self.fillColor = color.colorWithAlphaComponent(1).CGColor
        self.strokeColor = self.fillColor
        self.lineWidth = 0
        self.strokeEnd = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimationUp(ballTag: Int, duration:NSTimeInterval, circleSize:CGFloat, circleSpace:CGFloat, viewWidth: CGFloat) {
        layerTag = ballTag
        let distance_left = (circleSize + circleSpace) * (1.5 - CGFloat(ballTag))
        self.moveUp(duration, up: moveUpDist, left: distance_left, viewWidth: viewWidth)
    }
    
    func endAnimation(complition:(()->())? = nil) {
        didEndAnimation = complition
    }
    
    func moveUp(duration:NSTimeInterval, up: CGFloat,left: CGFloat, viewWidth: CGFloat) {
        
        self.hidden = false
        let move = CAKeyframeAnimation(keyPath: "position")
        let angle_1 = atan(Double(abs(left)) / Double(up))
        let angle_2 = M_PI -  angle_1 * 2
        let radii: Double = pow((pow(Double(left), 2)) + pow(Double(up), 2), 1 / 2) / (cos(angle_1) * 2)
        let centerPoint: CGPoint = CGPoint(x: viewWidth/2 - left, y: CGFloat(radii) - up)
        var endAngle: CGFloat = CGFloat(3 * M_PI_2)
        var startAngle: CGFloat = CGFloat(3 / 2 * M_PI - angle_2)
        var bezierPath = UIBezierPath()
        var clockwise:Bool = true
        
        if left > 0 {
            clockwise = false
            startAngle =  CGFloat(3 / 2 * M_PI + angle_2)
            endAngle = CGFloat(3 * M_PI_2)
        }
        
        bezierPath = UIBezierPath.init(arcCenter: centerPoint, radius: CGFloat(radii), startAngle: startAngle , endAngle: endAngle, clockwise: clockwise)
        move.path = bezierPath.CGPath
        move.duration = duration
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        move.delegate = self
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    func floatUpOrDown() {
        let move = CAKeyframeAnimation(keyPath: "position.y")
        move.values = [0,1,2,3,4,5,4,3,2,1,0,-1,-2,-3,-4,-5,-4,-3,-2,-1,0]
        move.duration = 1
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        move.additive = true
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    func stopFloatAnimation(ballTag: Int) {
        timer?.invalidate()
        self.hidden = true
        self.removeAllAnimations()
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        let animation:CAKeyframeAnimation = anim as! CAKeyframeAnimation
        if animation.keyPath == "position" {
            var timeDelay : Double = Double(UInt64(layerTag!) * NSEC_PER_SEC)
            timeDelay *= 0.2;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeDelay)), dispatch_get_main_queue(), { () -> Void in
                self.floatUpOrDown()
            })
//            timer = Timer.schedule(delay: timeDelay, repeatInterval: 1, handler: { (timer) -> Void in
//                self.floatUpOrDown()
//            })
        }
    }
}
