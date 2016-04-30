//
//  JHSwitch.swift
//  JHSwitch
//
//  Created by Lijie on 16/4/29.
//  Copyright © 2016年 HuatengIOT. All rights reserved.
//

import UIKit

private extension Double {
    var c: CGFloat {
        return CGFloat(self) / 255.0
    }
}

let JHSwitchDefaultTrackOnColor: UIColor = UIColor(red: 129.0.c, green: 198.0.c, blue: 221.c, alpha: 1.0)
let JHSwitchDefaultTrackOffColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
let JHSwitchDefaultThumbTintColor: UIColor = UIColor.whiteColor()
let JHSwitchDefaultThumbBorderColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
let JHSwitchDefaultAnimationScaleInterval: NSTimeInterval = 0.15
let JHSwitchDefaultAnimationSlideInterval: NSTimeInterval = 0.25
let JHSwitchDefaultAnimationTranslateInterval: NSTimeInterval = 0.3
let JHSwitchHeightWidthRatio: CGFloat = 1.6451612903
let kThumbOffset: CGFloat = 1.0
private let kThumbLockImageTag = 8030

typealias JHSwitchChangeHandler = (Bool) -> Void

class JHSwitch: UIControl, UIGestureRecognizerDelegate {

    // 开状态下的背景色
    var onTintColor: UIColor = JHSwitchDefaultTrackOnColor {
        didSet {
            self.track.onTintColor = self.onTintColor
        }
    }
    // 关状态下的背景色
    var contrastColor: UIColor = JHSwitchDefaultThumbTintColor {
        didSet {
            self.track.contrastColor = self.contrastColor
        }
    }
    // 纽扣的边框色
    var thumbBorderColor: UIColor = JHSwitchDefaultThumbBorderColor {
        didSet {
            self.thumb.layer.borderColor = self.thumbBorderColor.CGColor
        }
    }
    // 纽扣的 tintColor
    var thumbTintColor: UIColor = JHSwitchDefaultThumbTintColor {
        didSet {
            self.thumb.tintColor = self.thumbTintColor
        }
    }
    // 纽扣的背景色
    var thumbBackgroundColor: UIColor = JHSwitchDefaultThumbTintColor {
        didSet {
            self.thumb.backgroundColor = self.thumbBackgroundColor
        }
    }
    // 读取或者设置开关状态
    var on: Bool! {
        get {
            return self._on
        }
        set {
            self.setOn(newValue, animated: true)
        }
    }
    // 读取或者设置 是否显示锁定
    var locked: Bool! {
        get {
            return self._locked
        }
        set {
            self.setLock(self.locked)
        }
    }
    // 设置值改变后的回调
    var didChangeClosure: JHSwitchChangeHandler?
    
    // Todo
    var onImage: UIImage?
    var offImage: UIImage?
    var panActivationThreshold: CGFloat = 0.7
    var shouldConstrainFrame: Bool = true

    private var _on: Bool = true
    private var _locked: Bool = false
    private var track: JHTrack!
    private var thumb: JHThumb!
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JHSwitch.didTap(_:)))
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JHSwitch.didPan(_:)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSwitch()
    }
    convenience init(frame: CGRect, changeHandler: JHSwitchChangeHandler?) {
        self.init(frame: frame)
        
        self.didChangeClosure = changeHandler
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(self.frame)
        self.configureSwitch()
    }
    private func configureSwitch() {
        self.tapGestureRecognizer.delegate = self
        self.panGestureRecognizer.delegate = self
        self.addGestureRecognizer(self.tapGestureRecognizer)
        self.addGestureRecognizer(self.panGestureRecognizer)
        if self.track == nil {
            track = JHTrack(frame: self.bounds, onColor: self.onTintColor, offColor: self.tintColor, contrastColor: self.contrastColor)
            track.setOn(true, animated: false)
            self.addSubview(track)
        }
        if self.thumb == nil {
            let width = self.bounds.height - 2 * kThumbOffset
            thumb = JHThumb(frame: CGRect(x: kThumbOffset, y: kThumbOffset, width: width, height: width))
            self.addSubview(thumb)
        }
        self.tintColor = JHSwitchDefaultTrackOffColor
        self.backgroundColor = UIColor.clearColor()
        self.on = false
    }
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.track.tintColor = self.tintColor
    }
    override func drawRect(rect: CGRect) {
        self.thumb.backgroundColor = self.thumbBackgroundColor
        self.thumb.tintColor = self.thumbTintColor
        self.thumb.layer.cornerRadius = self.thumb.frame.height * 0.5
        self.thumb.layer.borderColor = self.thumbBorderColor.CGColor
        self.thumb.layer.borderWidth = 0.5
        self.thumb.layer.shadowColor = UIColor.grayColor().CGColor
        self.thumb.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.thumb.layer.shadowRadius = 0.8
        self.thumb.layer.shadowOpacity = 0.4
    }

    private func toggleState() {
        self.setOn(!self.on, animated: true)
    }
    private func setOn(on: Bool, animated: Bool) {
        if on == self.on {
            return
        }
        self._on = on
        
        self.setThumbOn(on, animated: animated)
        
        self.track.setOn(on, animated: animated)
        
        self.didChangeClosure?(on)
        
        self.sendActionsForControlEvents(.ValueChanged)
    }
    private func setLock(locked: Bool) {
        if locked == self.locked {
            return
        }
        self._locked = locked
        
        var lockImageView = self.track.viewWithTag(kThumbLockImageTag) as? UIImageView
        
        if let _ = lockImageView where !locked {
            lockImageView?.removeFromSuperview()
            lockImageView = nil
        }
        if lockImageView == nil && locked {
            guard let img = UIImage(named: "") else {
                return
            }
            lockImageView = UIImageView(image: img)
            lockImageView?.frame = CGRect(x: 7, y: 8, width: img.size.width, height: img.size.height)
            lockImageView?.tag = kThumbLockImageTag
            self.track.addSubview(lockImageView!)
            self.track.bringSubviewToFront(lockImageView!)
        }
    }
    private func setThumbOn(on: Bool, animated: Bool) {
        func setThumb() {
            var thumbFrame = self.thumb.frame
            if on {
                thumbFrame.origin.x = self.bounds.size.width - (thumbFrame.width + kThumbOffset)
            } else {
                thumbFrame.origin.x = kThumbOffset
            }
            self.thumb.frame = thumbFrame
        }
        if !animated {
            return setThumb()
        }
        UIView.animateWithDuration(JHSwitchDefaultAnimationTranslateInterval,
                                   delay: 0.0,
                                   usingSpringWithDamping: 10,
                                   initialSpringVelocity: 1,
                                   options: .CurveEaseOut,
                                   animations: { 
                                    setThumb()
            }, completion: nil)
    }
    private func setThumbIsTracking(tracking: Bool, animated: Bool) {
        func setThumb() {
            let position = self.on == true ? JHThumbPosition.Right : JHThumbPosition.Left
            if tracking {
                self.thumb.expandThumbOnPosition(position)
            } else {
                self.thumb.shrinkThumbOnPosition(position)
            }
            self.thumb.isTracking = tracking
        }
        if !tracking {
            return setThumb()
        }
        UIView.animateWithDuration(JHSwitchDefaultAnimationScaleInterval,
                                   delay: fabs(JHSwitchDefaultAnimationSlideInterval - JHSwitchDefaultAnimationScaleInterval),
                                   usingSpringWithDamping: 10,
                                   initialSpringVelocity: 1,
                                   options: .CurveEaseOut,
                                   animations: { 
                                    setThumb()
            }, completion: nil)
    }
    
    // MARK: - UIGestureRecognizer action
    
    func didTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            self.toggleState()
        }
    }
    func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            self.setThumbIsTracking(true, animated: true)
        case .Changed:
            let locationInThumb = gesture.locationInView(self.thumb)
            if (self.on && locationInThumb.x <= 0) || (!self.on && locationInThumb.x >= self.thumb.bounds.width) {
                self.toggleState()
            }
            if CGRectContainsPoint(self.bounds, gesture.locationInView(self)) {
                self.sendActionsForControlEvents(.TouchDragInside)
            } else {
                self.sendActionsForControlEvents(.TouchDragOutside)
            }
        case .Ended:
            self.setThumbIsTracking(false, animated: true)
        default: break
        }
    }
    
    // MARK: - Touches Event
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.sendActionsForControlEvents(.TouchDown)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.sendActionsForControlEvents(.TouchUpInside)
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        self.sendActionsForControlEvents(.TouchUpOutside)
    }
    
}
