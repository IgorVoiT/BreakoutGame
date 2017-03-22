//
//  File.swift
//  BreakoutGame
//
//  Created by Игорь on 21.02.17.
//  Copyright © 2017 Игорь. All rights reserved.
//

import Foundation
import UIKit


extension UIDynamicItemBehavior {
    
    func limitLinearVelocity(min: CGFloat, max: CGFloat,
                             forItem item: UIDynamicItem) {
        
        guard min < max else {return}
        
        let itemVelocity = linearVelocity(for: item)
        if itemVelocity.magnitude <= 0.0 { return }
        /*
        (item as? UIView)?.backgroundColor = UIColor.white
        switch itemVelocity.magnitude {
        case  let x where x < CGFloat(600.0) && x >= min :
            (item as? UIView)?.backgroundColor = UIColor.yellow
        case  let x where x < 800 && x >= 600 :
            (item as? UIView)?.backgroundColor = UIColor.orange
        case  let x where x  < 1000 && x >= 800 :
            (item as? UIView)?.backgroundColor = UIColor.red
        case  let x where  x >= 1000 :
            (item as? UIView)?.backgroundColor = UIColor.magenta
        default:
            (item as? UIView)?.backgroundColor = UIColor.white
        }
        */
        if itemVelocity.magnitude < (min - 1) {
            let deltaVelocity =
                min/itemVelocity.magnitude * itemVelocity - itemVelocity
            addLinearVelocity(deltaVelocity, for: item)
            print("min")
        }
        if itemVelocity.magnitude > max  {
            let deltaVelocity =
                max/itemVelocity.magnitude * itemVelocity - itemVelocity
            addLinearVelocity(deltaVelocity, for: item)
            print("max")
        }
    }
    
}


extension CGPoint {
    var angle: CGFloat {
        get { return CGFloat(atan2(self.y, self.x)) }
    }
    var magnitude: CGFloat {
        get { return CGFloat(sqrt(self.x*self.x + self.y*self.y)) }
    }
}

extension CGFloat {
    static func random(lower: CGFloat = 1, _ upper: CGFloat = 2) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

extension Int {
    static func random(min: Int, _ max: Int) -> Int {
        guard min < max else {return min}
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
}

prefix func -(left: CGPoint) -> CGPoint {
    return CGPoint(x: -left.x, y: -left.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left*right.x, y: left*right.y)
}
