//
//  gameObjectsBehavior.swift
//  BreakoutGame
//
//  Created by Игорь on 20.02.17.
//  Copyright © 2017 Игорь. All rights reserved.
//

import UIKit

class GameObjectsBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate  {
    
    
    var hitBlock : ((_ behaviour: UICollisionBehavior, _ ball: UIView, _ blockIndex: Int)->())?
    var moveBlock : ((_ behaviour: UICollisionBehavior)->())?
    
    private var ballAngle: CGFloat = 10
    
    private let gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.magnitude = 0
        return gravity
    }()
    
    private lazy var collider: UICollisionBehavior  = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.collisionDelegate = self
        return collider
    }()
    
    private let ballBehavior: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.friction = 0.0
        dib.resistance = 0.0
        dib.elasticity = 1.0
        return dib
    }()
    
    
    override init() {
        super.init()
        addChildBehavior(ballBehavior)
        addChildBehavior(gravity)
        addChildBehavior(collider)
    }
    
    //boundaries
    func addBoundary(boundary: UIBezierPath, name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: boundary)
    }
    
    func removeBoundary(name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
    }
    
    
    //ball's Behaviour
    func addBallBehavior(item: UIDynamicItem) {
        collider.addItem(item)
        gravity.addItem(item)
        ballBehavior.addItem(item)
    }
    func removeBallBehavior(item: UIDynamicItem) {
        collider.removeItem(item)
        gravity.removeItem(item)
        ballBehavior.removeItem(item)
    }
    
    
    func launchBall(ball: UIView, magnitude: CGFloat, angle: CGFloat) {
        let pushBehaiour = UIPushBehavior(items: [ball], mode: .instantaneous)
        pushBehaiour.magnitude = -magnitude
        pushBehaiour.angle = angle
  
        
        pushBehaiour.action = { [weak pushBehaiour] in
            if !pushBehaiour!.active { self.removeChildBehavior(pushBehaiour!) }
        }
        
        addChildBehavior(pushBehaiour)
    }
    
    //change ball angle if stack
    func ballIsStuck(ball: UIDynamicItem) {
        let angle = ballBehavior.linearVelocity(for: ball).angle
        let yVelocity = CGFloat(Int.random(min: -100, 100))
        if ballBehavior.linearVelocity(for: ball) != CGPoint(x: 0, y: 0) {
            switch angle {
            case -0.01 ... 0.01:
                fallthrough
            case 3.13 ... 3.15:
                ballBehavior.addLinearVelocity(CGPoint(x: 0, y: yVelocity), for: ball)
            default:
                break
            }
        }
    }
    
    //velocity
    func addVelocity(velocity: CGPoint, item: UIDynamicItem) {
        ballBehavior.addLinearVelocity(velocity, for: item)
    }
    func getVelocity(item: UIDynamicItem) -> CGPoint {
        return ballBehavior.linearVelocity(for: item)
    }
    
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if getVelocity(item: item) != CGPoint(x: 0, y: 0) {
            if identifier as? String == "Bottom Display Boundary" {
                let itemVelocity = getVelocity(item: item)
                addVelocity(velocity: -itemVelocity, item: item)
                moveBlock?(behavior)
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        ballBehavior.limitLinearVelocity(min: 500, max: 1100, forItem: item)
        ballIsStuck(ball: item)
        if let index = identifier as? String {
            if let blockIndex = Int(index) {
                hitBlock?(behavior,item as! UIView,blockIndex)
            }
        }
        
    }
    
}
