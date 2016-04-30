//
//  JHThumb.swift
//  JHSwitch
//
//  Created by Lijie on 16/4/29.
//  Copyright © 2016年 HuatengIOT. All rights reserved.
//

import UIKit

let kJHThumbTrackingGrowthRatio: CGFloat = 1.2

enum JHThumbPosition {
    case Left
    case Right
    
    func resizeThumbWithOriginFrame(frame: CGRect, expand: Bool) -> CGRect {
        var rect = frame
        if expand {
            let deltaWidth = frame.width * (kJHThumbTrackingGrowthRatio - 1.0)
            rect.size.width += deltaWidth
            if self == .Right {
                rect.origin.x -= deltaWidth
            }
        } else {
            let deltaWidth = frame.width * (1 - 1 / kJHThumbTrackingGrowthRatio)
            rect.size.width -= deltaWidth
            if self == .Right {
                rect.origin.x += deltaWidth
            }
        }
        return rect
    }
}

final class JHThumb: UIView {
    
    var isTracking: Bool = false
    
    func expandThumbOnPosition(position: JHThumbPosition) -> CGRect {
        if self.isTracking {
            return self.frame
        }
        self.frame = position.resizeThumbWithOriginFrame(self.frame, expand: true)
        return self.frame
    }
    func shrinkThumbOnPosition(position: JHThumbPosition) -> CGRect {
        if !self.isTracking {
            return self.frame
        }
        self.frame = position.resizeThumbWithOriginFrame(self.frame, expand: false)
        return self.frame
    }
}
