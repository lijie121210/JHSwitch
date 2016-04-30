//
//  JHTrack.swift
//  JHSwitch
//
//  Created by Lijie on 16/4/29.
//  Copyright © 2016年 HuatengIOT. All rights reserved.
//

import UIKit

private let kDefaultAnimationContrastResizeLength: NSTimeInterval = 0.25
private let kTrackContrastShrinkFactor: CGFloat = 0.0001

final class JHTrack: UIView {
    
    var contrastColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.contrastView.backgroundColor = self.contrastColor
        }
    }
    var onTintColor: UIColor = JHSwitchDefaultTrackOnColor {
        didSet {
            self.onView.backgroundColor = self.onTintColor
        }
    }
    
    private var on: Bool!
    private var contrastView: UIView!
    private var onView: UIView!
    
    init(frame: CGRect, onColor: UIColor, offColor: UIColor, contrastColor: UIColor) {
        super.init(frame: frame)
        
        var contrastRect = frame
        contrastRect.size.width = frame.width - 2 * kThumbOffset
        contrastRect.size.height = frame.height - 2 * kThumbOffset
        let corner = frame.height * 0.5

        self.onTintColor = onColor
        self.tintColor = offColor
        self.contrastColor = contrastColor
        self.layer.cornerRadius = corner
        self.backgroundColor = offColor

        contrastView = UIView(frame: contrastRect)
        contrastView.center = self.center
        contrastView.backgroundColor = contrastColor
        contrastView.layer.cornerRadius = contrastRect.height * 0.5
        self.addSubview(contrastView)
        
        onView = UIView(frame: frame)
        onView.center = self.center
        onView.backgroundColor = onColor
        onView.layer.cornerRadius = corner
        self.addSubview(onView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        self.backgroundColor = self.tintColor
    }
    
    func expandContrastView() {
        self.contrastView.transform = CGAffineTransformMakeScale(kTrackContrastShrinkFactor, kTrackContrastShrinkFactor)
        self.contrastView.transform = CGAffineTransformMakeScale(1.0, 1.0)
    }
    func shrinkContrastView() {
        self.contrastView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        self.contrastView.transform = CGAffineTransformMakeScale(kTrackContrastShrinkFactor, kTrackContrastShrinkFactor)
    }
    
    func setOn(on: Bool, animated: Bool) {
        if let o = self.on where o == on {
            return
        }
        func actionClosure () {
            if on {
                self.onView.alpha = 1.0
                self.shrinkContrastView()
            } else {
                self.onView.alpha = 0.0
                self.expandContrastView()
            }
        }
        if !animated {
            return actionClosure()
        }
        UIView.animateWithDuration(kDefaultAnimationContrastResizeLength, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            actionClosure()
            }, completion: nil)
    }
}
